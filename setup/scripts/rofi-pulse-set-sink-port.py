#!/usr/bin/env python3

# Title: rofi-pulse-set-sink-port
# Description: Use Rofi to set PulseAudio sink port to use (e.g. Line Out vs Headphone).
# Author: William Chanrico
# Date: 05-February-2022

"""
Use Rofi to set PulseAudio sink port to use (e.g. Line Out vs Headphone)
"""

from rofi import Rofi
import pulsectl

# Tell rofi to use default sink (skip the sink selection)
USE_DEFAULT_SINK = True

def main():
    pulse = pulsectl.Pulse()
    rofi = Rofi()

    sinks = pulse.sink_list()

    current_default_sink_name = pulse.server_info().default_sink_name
    for i, sink in enumerate(sinks):
        if sink.name == current_default_sink_name:
            current_default_sink_index = i
    if current_default_sink_index is None:
        print("Could not find default sink")
        return

    # Use default sink as initial target sink to configure
    target_sink = sinks[current_default_sink_index]

    # Ask user for the target sink to configure (override target_sink)
    if not USE_DEFAULT_SINK:
        selection_sinks = []
        for sink in sinks:
            try:
                selection_sinks.append(sink.description)
            except KeyError:
                selection_sinks.append(sink.proplist['media.name'])
        selection_sinks_input_index, _ = rofi.select(
            "Select sink", selection_sinks, select=current_default_sink_index
        )
        if selection_sinks_input_index == -1: # Hit ECS
            return
        target_sink = sinks[selection_sinks_input_index]

    # Get the card info to find the available input/output ports
    target_card = pulse.card_list()[target_sink.card]

    # Ask user whether they want to configure input or output port
    selection_directions = ['input (not implemented)', 'output']
    selection_directions_input_index, _ = rofi.select(
            f"Select port direction [{target_sink.description}]",
            selection_directions,
            select=1
    )
    if selection_directions_input_index == -1: # Hit ECS
        return
    target_port_direction = selection_directions[selection_directions_input_index]

    # Ask user which target port to use
    selection_ports = []
    for i, port in enumerate(target_card.port_list):
        if port.direction == target_port_direction and port.available == "yes":
            selection_ports.append(port)
    selection_ports_input_index, _ = rofi.select(
        "Select target port", [p.description for p in selection_ports], select=0
    )
    if selection_ports_input_index == -1: # Hit ECS
        return
    target_port = selection_ports[selection_ports_input_index]

    # Set the sink port
    pulse.sink_port_set(target_sink.index, target_port.name)

if __name__ == '__main__':
    main()
