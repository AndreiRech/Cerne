//
//  CerneTests.swift
//  CerneTests
//
//  Created by Andrei Rech on 04/09/25.
//

import Testing
@testable import Cerne

struct CerneTests {

    @Test func example() {
        // Given
        var number = 1
        
        // When
        number += 1
        
        // Then
        #expect(number == 2)
    }

}
