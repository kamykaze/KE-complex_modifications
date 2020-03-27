#!/usr/bin/env ruby

require 'json'
require_relative '../lib/karabiner.rb'

# TODO:
# [ ] Double/Triple Tap Shorcuts
# [ ] Shift Mode
# [ ] Swtich Mode
#     [ ] Numbers
#

def main
  puts JSON.pretty_generate(
    "title" => "TAP Device (www.tapwithus.com) Emulation (beta)",
    "rules" => [
      {
        "description" => "TAP Emulation Mode [fn as Trigger Key]",
        "manipulators" => generate_tap_mode("fn"),
        # If you want to use other trigger keys for tap mode, just change this above line and run
        #
        # $ make
        #
        # in Terminal to generate your new JSON file at public/json/tap_emulation_mode.json.
        #
        # Copy it to ~/.config/karabiner/assets/complex_modifications then you can enable it in Karabiner-Elements.
        #
        # Modifier keys such as "command", "option" or "control" cannot be used here.
      },
      #{
      #  "description" => "TAP Mode [D as Trigger Key]",
      #  "manipulators" => generate_tap_mode("d"),
      #},
    ],
  )
end

def generate_tap_mode(trigger_key)
  key_t="n"
  key_1="j"
  key_2="k"
  key_3="l"
  key_4="semicolon"
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => trigger_key,
        "modifiers" => { "optional" => ["any"] },
      },
      "to_if_held_down" => [
        Karabiner.set_variable("tap_emulation_mode", 1),
      ],
      "to_if_alone" => [
        Karabiner.set_variable("tap_emulation_mode", 1),
      ],
      "conditions" => [
        Karabiner.variable_if('tap_emulation_mode', 0),
      ]
    },
    {
      "type" => "basic",
      "from" => {
        "key_code" => trigger_key,
        "modifiers" => { "optional" => ["any"] },
      },
      "to_if_held_down" => [
        Karabiner.set_variable("tap_emulation_mode", 1),
      ],
      "to_if_alone" => [
        Karabiner.set_variable("tap_emulation_mode", 0),
      ],
      "conditions" => [
        Karabiner.variable_if('tap_emulation_mode', 1),
      ]
    },
    ## FIVE FINGERS
    # Space
    generate_tap_mode_single_rule([key_t, key_1, key_2, key_3, key_4], "h", [], trigger_key),

    ## FOUR FINGERS
    # One Finger Up (HCVJR)
    generate_tap_mode_single_rule([key_1, key_2, key_3, key_4], "h", [], trigger_key),
    generate_tap_mode_single_rule([key_t, key_2, key_3, key_4], "c", [], trigger_key),
    generate_tap_mode_single_rule([key_t, key_1, key_3, key_4], "v", [], trigger_key),
    generate_tap_mode_single_rule([key_t, key_1, key_2, key_4], "j", [], trigger_key),
    generate_tap_mode_single_rule([key_t, key_1, key_2, key_3], "r", [], trigger_key),

    ## THREE FINGERS
    # Shift, Delete, Swtich
    #generate_tap_mode_single_rule([key_t, key_1, key_2], SHIFT_MODE, [], trigger_key),
    generate_tap_mode_single_rule([key_1, key_2, key_3], "delete_or_backspace", [], trigger_key),
    #generate_tap_mode_single_rule([key_2, key_3, key_4], SWITCH_MODE, [], trigger_key),
    # W, G, X
    generate_tap_mode_single_rule([key_t, key_2, key_4], "w", [], trigger_key),
    generate_tap_mode_single_rule([key_t, key_2, key_3], "g", [], trigger_key),
    generate_tap_mode_single_rule([key_1, key_3, key_4], "x", [], trigger_key),
    # F, Q
    generate_tap_mode_single_rule([key_t, key_1, key_3], "f", [], trigger_key),
    generate_tap_mode_single_rule([key_1, key_2, key_4], "q", [], trigger_key),
    # P, Return
    generate_tap_mode_single_rule([key_t, key_1, key_4], "p", [], trigger_key),
    generate_tap_mode_single_rule([key_t, key_3, key_4], "return_or_enter", [], trigger_key),

    ## TWO FINGERS
    # Two Fingers Together (NTLS)
    generate_tap_mode_single_rule([key_t, key_1], "n", [], trigger_key),
    generate_tap_mode_single_rule([key_1, key_2], "t", [], trigger_key),
    generate_tap_mode_single_rule([key_2, key_3], "l", [], trigger_key),
    generate_tap_mode_single_rule([key_3, key_4], "s", [], trigger_key),
    # Two Fingers Skipping One (DMZ)
    generate_tap_mode_single_rule([key_t, key_2], "d", [], trigger_key),
    generate_tap_mode_single_rule([key_1, key_3], "m", [], trigger_key),
    generate_tap_mode_single_rule([key_2, key_4], "z", [], trigger_key),
    # Two Fingers Skipping Two (KB)
    generate_tap_mode_single_rule([key_t, key_3], "k", [], trigger_key),
    generate_tap_mode_single_rule([key_1, key_4], "b", [], trigger_key),
    # Y
    generate_tap_mode_single_rule([key_t, key_4], "y", [], trigger_key),
    # Vowels
    generate_tap_mode_single_rule([key_t],"a", [], trigger_key),
    generate_tap_mode_single_rule([key_1],"e", [], trigger_key),
    generate_tap_mode_single_rule([key_2],"i", [], trigger_key),
    generate_tap_mode_single_rule([key_3],"o", [], trigger_key),
    generate_tap_mode_single_rule([key_4],"u", [], trigger_key),
  ].flatten
end

def generate_tap_mode_single_rule(from_key_code_array, to_key_code, to_modifier_key_code_array, trigger_key)
  from_simultaneous_keys = []
  from_key_code_array.each do |k|
    from_simultaneous_keys << { "key_code" => k }
  end
  [
    {
      "type" => "basic",
      "from" => {
        "simultaneous" => from_simultaneous_keys,
        "simultaneous_options" => {
          "detect_key_down_uninterruptedly" => true,
        },
        #"modifiers" => { "optional" => ["any"] },
      },
      "to" => [
        {
          "key_code" => to_key_code,
          "modifiers" => to_modifier_key_code_array
        }
      ],
      "conditions" => [
        Karabiner.variable_if('tap_emulation_mode', 1),
      ]
    }
  ]
end
main()
