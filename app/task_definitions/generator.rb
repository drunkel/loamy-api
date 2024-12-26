class Generator
  def self.generate
    require "fileutils"
    require "yaml"

    # Directory to save .yml files
    output_dir = "./app/task_definitions"

    # List of maintenance tasks with their details
    maintenance_tasks = [
      { task: "Basic Bike Cleaning",
        frequency: {
          conditions: [ "after_wet_ride", "after_muddy_ride" ],
          time_based: { days: 7 }
        },
        tools: "Bucket, soft brushes (different ones for drivetrain/frame), bike-specific cleaner, garden sprayer or hose",
        min_time_estimate: 15, max_time_estimate: 30,
        details: "Clean frame with gentle water pressure, avoid spraying directly into bearings. Use bike-specific cleaner for stubborn dirt. Pay special attention to seals and pivots.",
        level: "Beginner" },

      { task: "Chain Maintenance",
        frequency: {
          distance_km: 150,
          conditions: [ "when_noisy" ]
        },
        tools: "Chain checker tool, bike-specific chain lube (wet or dry depending on conditions), clean rags",
        min_time_estimate: 10, max_time_estimate: 15,
        details: "Wipe chain thoroughly before lubing. Apply lube to inner chain rollers only, let sit for 5 minutes, then wipe excess thoroughly. Excess lube attracts dirt.",
        level: "Beginner" },

      { task: "Drivetrain Deep Clean",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "when_grimy" ]
        },
        tools: "Degreaser, chain cleaning tool, old toothbrush, clean rags, chain lube",
        min_time_estimate: 30, max_time_estimate: 45,
        details: "Remove chain if possible. Clean cassette, chainrings, and derailleur pulleys. Use degreaser sparingly and keep away from bearings. Re-lube chain after cleaning.",
        level: "Intermediate" },

      { task: "Brake System Check",
        frequency: {
          time_based: { days: 14 },
          distance_km: 200
        },
        tools: "Flashlight, metric Allen keys, rotor truing tool (optional)",
        min_time_estimate: 10, max_time_estimate: 20,
        details: "Check pad thickness (replace under 1.5mm), rotor true, caliper alignment, and lever feel. Listen for pad rub or squealing.",
        level: "Beginner" },

      { task: "Hydraulic Brake Bleed",
        frequency: {
          time_based: { months: 6 },
          conditions: [ "when_spongy_feel" ]
        },
        tools: "Manufacturer-specific brake bleed kit, correct brake fluid (DOT or mineral oil), clean rags, isopropyl alcohol",
        min_time_estimate: 45, max_time_estimate: 90,
        details: "Different systems require different fluids - DOT fluid for SRAM, mineral oil for Shimano. Professional service recommended for novices.",
        level: "Expert" },

      { task: "Basic Suspension Maintenance",
        frequency: {
          time_based: { days: 7 },
          conditions: [ "after_wet_ride", "after_muddy_ride" ]
        },
        tools: "Clean cloth, suspension pump",
        min_time_estimate: 5, max_time_estimate: 10,
        details: "Clean stanchions, check for smooth operation, inspect seals for damage, check sag and rebound settings. Look for oil weeping or unusual noises.",
        level: "Beginner" },

      { task: "Full Suspension Service",
        frequency: {
          time_based: { months: 12 },
          ride_hours: 100,
          conditions: [ "when_performance_degraded", "when_oil_weeping" ]
        },
        tools: "Manufacturer-specific service tools, suspension oils, seals kit, nitrogen charge (if applicable)",
        min_time_estimate: 60, max_time_estimate: 120,
        details: "Complete disassembly, oil and seal replacement, damper service, air spring service. Professional service strongly recommended unless specifically trained.",
        level: "Expert" },

      { task: "Tire Setup and Check",
        frequency: {
          pressure_check: { days: 7 },
          condition_check: { days: 30 },
          sealant_check: { months: 2 }
        },
        tools: "Digital tire pressure gauge, tubeless sealant, valve core tool",
        min_time_estimate: 5, max_time_estimate: 20,
        details: "Check pressure when tires are cold. Inspect for cuts/wear. For tubeless: check sealant every 2-3 months, more frequently in hot climates.",
        level: "Beginner" },

      { task: "Drivetrain Wear Check",
        frequency: {
          time_based: { days: 30 },
          distance_km: 500
        },
        tools: "Chain wear checker tool, ruler (for cassette/chainring check)",
        min_time_estimate: 5, max_time_estimate: 10,
        details: "Check chain stretch - replace at 0.5% wear for 11/12 speed, 0.75% for others. Inspect cassette teeth for sharks-fin shape.",
        level: "Intermediate" },

      { task: "Wheel Maintenance",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "after_hard_impact" ]
        },
        tools: "Spoke wrench, tension meter (optional), truing stand (optional)",
        min_time_estimate: 20, max_time_estimate: 45,
        details: "Check spoke tension uniformity, wheel true, and hub bearing play. Listen for creaks or clicks.",
        level: "Intermediate" },

      { task: "Frame and Bolt Check",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "after_crash" ]
        },
        tools: "Torque wrench, metric Allen keys, grease",
        min_time_estimate: 20, max_time_estimate: 30,
        details: "Check all frame bolts with torque wrench, especially stem, handlebar, and suspension pivots. Inspect frame for cracks.",
        level: "Intermediate" },

      { task: "Bearing Systems Check",
        frequency: {
          time_based: { months: 3 },
          distance_km: 500
        },
        tools: "Metric Allen keys, appropriate bearing tools",
        min_time_estimate: 15, max_time_estimate: 30,
        details: "Check headset, bottom bracket, and hub bearings for smooth operation and play. Clean and regrease if necessary.",
        level: "Intermediate" },

      { task: "Cable System Maintenance",
        frequency: {
          time_based: { months: 3 },
          conditions: [ "when_shifting_degrades", "when_braking_degrades" ]
        },
        tools: "Cable cutters, housing cutters, metric Allen keys, lubricant",
        min_time_estimate: 30, max_time_estimate: 60,
        details: "Check for fraying, rust, or stiction. Ensure proper cable tension. Replace inner cables annually or when damaged.",
        level: "Intermediate" },

      { task: "Dropper Post Service",
        frequency: {
          ride_hours: 100,
          conditions: [ "when_slow_return", "when_sticky" ]
        },
        tools: "Clean rags, manufacturer-specific service kit",
        min_time_estimate: 10, max_time_estimate: 90,
        details: "Clean and grease collar/seals. Check cable tension. Internal service requires specific tools and knowledge.",
        level: "Intermediate/Expert" },

      { task: "Comprehensive Service",
        frequency: {
          time_based: { months: 12 },
          distance_km: 2000
        },
        tools: "Full workshop toolkit, bearing tools, suspension tools",
        min_time_estimate: 180, max_time_estimate: 240,
        details: "Complete disassembly, deep clean, bearing check/replacement, suspension service, frame inspection. Best done by professional.",
        level: "Expert" },

      { task: "Shifting Adjustment",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "when_shifting_imprecise", "after_crash" ]
        },
        tools: "Metric Allen keys, Phillips screwdriver, repair stand (recommended)",
        min_time_estimate: 15, max_time_estimate: 30,
        details: "Check derailleur hanger alignment, adjust limit screws, index gears, check B-tension. Crucial for preventing chain damage.",
        level: "Intermediate" },

      { task: "Brake Rotor Maintenance",
        frequency: {
          time_based: { months: 3 },
          conditions: [ "when_braking_performance_decreases", "after_contamination" ]
        },
        tools: "Isopropyl alcohol, clean rags, torque wrench, rotor truing tool",
        min_time_estimate: 10, max_time_estimate: 20,
        details: "Clean rotors with alcohol, check for warping, verify rotor bolts are torqued correctly. Never touch rotors with bare hands.",
        level: "Beginner" },

      { task: "Frame Protection Check",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "after_rock_strike", "after_crash" ]
        },
        tools: "Spare frame protection tape, isopropyl alcohol, clean rags",
        min_time_estimate: 10, max_time_estimate: 20,
        details: "Inspect chain stay protection, down tube guards, and any areas where cables contact frame. Replace worn protection to prevent frame damage.",
        level: "Beginner" },

      { task: "Pedal Service",
        frequency: {
          time_based: { months: 6 },
          conditions: [ "when_clicking", "after_submersion" ]
        },
        tools: "Pedal wrench, bearing grease, appropriate spanners for your pedal type",
        min_time_estimate: 20, max_time_estimate: 40,
        details: "Check pedal bearings for play, clean and regrease threads, inspect cleats for wear if using clipless. Replace cleats if worn.",
        level: "Intermediate" },

      { task: "Seatpost Maintenance",
        frequency: {
          time_based: { months: 3 },
          conditions: [ "when_creaking", "after_wet_rides" ]
        },
        tools: "Grease or carbon paste, torque wrench, cleaning supplies",
        min_time_estimate: 10, max_time_estimate: 20,
        details: "Remove, clean, and regrease post (or apply carbon paste for carbon posts). Check torque settings. Prevent seizure and creaking.",
        level: "Beginner" },

      { task: "Electronic System Check",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "before_long_ride", "after_firmware_update" ]
        },
        tools: "Manufacturer's app, charging cables, diagnostic tools",
        min_time_estimate: 5, max_time_estimate: 15,
        details: "Check battery levels, update firmware, verify all connections. Includes electronic shifting, power meters, suspension systems.",
        level: "Beginner" },

      { task: "Storage Preparation",
        frequency: {
          conditions: [ "before_storage" ]
        },
        tools: "Basic tool kit, chain lube, tire inflator",
        min_time_estimate: 30, max_time_estimate: 60,
        details: "Clean thoroughly, lubricate chain and cables, inflate tires to higher pressure, store in dry place. For e-bikes, follow battery storage guidelines.",
        level: "Intermediate" },

      { task: "Riding Mode Setup",
        frequency: {
          conditions: [ "seasonal_change", "conditions_change" ]
        },
        tools: "Shock pump, tire pressure gauge, suspension setup card",
        min_time_estimate: 20, max_time_estimate: 40,
        details: "Adjust tire pressure, suspension settings, and cockpit setup for seasonal conditions. Record settings for future reference.",
        level: "Intermediate" },

      { task: "Accessory Maintenance",
        frequency: {
          time_based: { days: 30 },
          conditions: [ "when_loose", "when_noisy" ]
        },
        tools: "Basic tool kit, waterproof grease",
        min_time_estimate: 10, max_time_estimate: 20,
        details: "Check and maintain bottle cages, bags, lights, computers, and mounts. Clean contact points, check mounting bolts, verify functionality.",
        level: "Beginner" }
    ]

    # Create directory if it doesn't exist
    FileUtils.mkdir_p(output_dir)

    # Write each task to an individual .yml file
    maintenance_tasks.each_with_index do |task, index|
      filename = "#{output_dir}/#{task[:task].gsub(" ", "_").downcase}.yml"
      File.open(filename, "w") do |file|
        file.puts "task: \"#{task[:task]}\""
        file.puts "frequency: #{task[:frequency].to_yaml}"
        file.puts "tools: \"#{task[:tools]}\""
        file.puts "min_time_estimate: #{task[:min_time_estimate]}"
        file.puts "max_time_estimate: #{task[:max_time_estimate]}"
        file.puts "details: \"#{task[:details]}\""
        file.puts "level: \"#{task[:level]}\""
      end
    end

    puts "YAML files created successfully."
  end
end
