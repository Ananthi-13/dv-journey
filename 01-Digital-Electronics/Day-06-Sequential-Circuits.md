## What is a Sequential Circuit?
## Definition
A sequential circuit is a digital circuit whose output depends on both:
- the current inputs, and
- the previous state (stored information).
In other words, it has memory.
## Why do we need Sequential Circuits?
Imagine a traffic light.

It doesn't simply depend on a sensor.

It must remember:
Red
 ↓
Green
 ↓
Yellow
 ↓
Red

Without memory, every second it would forget its current state.

Other examples:
- CPU instruction execution
- Stopwatch
- Digital clock
- Elevator controller
- Washing machine
- Vending machine
All of these need memory.
## What is a Clock?
A clock is a periodic digital signal that synchronizes operations in a digital system.
RTL (Verilog) Perspective
In RTL, sequential logic is described using an edge-triggered always block.

Example:
always @(posedge clk)
begin
    q <= d;
end

Meaning:
- Wait for the positive edge of the clock.
- Copy d into q.
This models a D Flip-Flop.

Notice the use of non-blocking assignment (<=), which is standard for sequential logic.
