//
//  ARMeasurmentEnum.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 23/09/25.
//

enum ARMeasurementState {
    case starting
    case readyToMeasure
    case firstPointPlaced
    case measurementCompleted(distance: Float)
}
