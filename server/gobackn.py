

import random
import time

class GoBackN:
    def __init__(self, window_size, packet_count, packet_size, error_rate):
        self.window_size = window_size
        self.packet_count = packet_count
        self.packet_size = packet_size
        self.error_rate = error_rate
        self.sender_window = []
        self.receiver_window = []
        self.ack_expected = 0
        self.next_sequence_num = 0
        self.packets_sent = 0

    def sender(self):
        while self.next_sequence_num < self.packet_count:
            if len(self.sender_window) < self.window_size:
                packet = self.create_packet(self.next_sequence_num)
                self.sender_window.append(packet)
                self.next_sequence_num += 1
                self._send_packet(packet)
                self.packets_sent += 1
            else:
                if self._receive_ack():
                    self.sender_window.pop(0)
                else:
                    self._resend_packets()

    def _send_packet(self, packet):
        print(f"Sending packet {packet['sequence_num']}")
        # Simulate packet transmission delay
        time.sleep(0.1)
        # Simulate packet loss or corruption
        if random.random() < self.error_rate:
            print(f"Packet {packet['sequence_num']} lost or corrupted")
            return
        # Packet received successfully
        self.receiver_window.append(packet)

    def _receive_ack(self):
        # Simulate ACK transmission delay
        time.sleep(0.1)
        # Simulate ACK loss or corruption
        if random.random() < self.error_rate:
            print("ACK lost or corrupted")
            return False
        # ACK received successfully
        ack = self.ack_expected
        print(f"Received ACK {ack}")
        self.ack_expected += 1
        return True

    def _resend_packets(self):
        print("Timeout: Resending packets")
        for packet in self.sender_window:
            self._send_packet(packet)

    def create_packet(self, sequence_num):
        return {
            'sequence_num': sequence_num,
            'data': f"Packet {sequence_num} data"
        }

    def run(self):
        self.sender()
        print("Transmission complete")


# Example usage:
if __name__ == "__main__":
    window_size = 5
    packet_count = 20
    packet_size = 10
    error_rate = 0.1  # 10% error rate

    go_back_n = GoBackN(window_size, packet_count, packet_size, error_rate)
    go_back_n.run()
