sig Person {
    location: one Location  // Every person has exactly one location
}


sig Material {
    location: one Location  // Every material has exactly one location
}


abstract sig Location {}

sig Dwelling extends Location {}   // Where people live
sig Warehouse extends Location {}  // Where materials are stored
sig Workplace extends Location {
    requiredPeople: Int,      // Number of people required to complete work
    requiredMaterials: set Material // Materials required to complete work
}

abstract sig Vehicle {
    currentLocation: one Location  // Each vehicle has a location
}

// Passenger vehicles with maxSeats constraint
sig PassengerVehicle extends Vehicle {
    maxSeats: Int,
    passengers: set Person
} {
    #passengers <= maxSeats
}

// Cargo vehicles with maxCapacity constraint
sig CargoVehicle extends Vehicle {
    maxCapacity: Int,
    cargo: set Material
} {
    #cargo <= maxCapacity
}

// Ensure workplaces have the necessary resources
fact WorkRequirements {
    all w: Workplace | 
        # { p: Person | p.location = w } >= w.requiredPeople and
        w.requiredMaterials in { m: Material | m.location = w }
}

// Ensure people are either in a dwelling, warehouse, workplace, or vehicle
fact ValidPersonLocation {
    all p: Person | p.location in (Dwelling + Warehouse + Workplace + Vehicle)
}

// Ensure materials are always stored in a warehouse or in a cargo vehicle
fact ValidMaterialLocation {
    all m: Material | m.location in (Warehouse + CargoVehicle)
}


run {} for 10
