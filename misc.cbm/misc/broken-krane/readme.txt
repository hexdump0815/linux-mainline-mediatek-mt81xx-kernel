my krane is a bit special as it hangs at boot once every few boots (i guess in more
than 20% of the cases) due to mmc errors:

[   23.772773] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd/data/mrq
[   23.780030] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting mrq=000000001b0b4b2c cmd=18
[   23.788561] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd=18
[   24.232766] cros-ec-spi spi2.0: SPI transfer timed out
[   24.237921] spi_master spi2: failed to transfer one message from queue
[   24.244450] cros-ec-spi spi2.0: spi transfer failed: -110
[   28.892771] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd/data/mrq
[   28.900016] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting mrq=00000000f4523031 cmd=13
[   28.908554] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd=13
[   34.012771] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd/data/mrq
[   34.020014] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting mrq=00000000f4523031 cmd=13
[   34.028547] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd=13
[   34.472766] cros-ec-spi spi2.0: SPI transfer timed out
[   34.477917] spi_master spi2: failed to transfer one message from queue
[   34.484446] cros-ec-spi spi2.0: spi transfer failed: -110
[   39.132773] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd/data/mrq
[   39.139993] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting mrq=00000000f4523031 cmd=12
[   39.148517] mtk-msdc 11230000.mmc: msdc_request_timeout: aborting cmd=12
[   39.296757] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[   39.302842] rcu:     0-...0: (0 ticks this GP) idle=db5/1/0x4000000000000002 softirq=1540/1540 fqs=2618

and i was not able to find the root cause of the problem as my kappa is working perfectly
fine with the same kernel ... another problem is that again every few successful boots
(i.e. no mmc errors) the battery is not detected properly and the system seems to do an
emergency shutdown immediately after startup - sometimes the following line in /etc/rc.local
to retry getting the battery info seemed to help but other times it did not in the end:

( rmmod sbs-battery; sleep 5; modprobe sbs-battery; sleep 5; systemctl restart upower ) &

the three files in this dir contain changes to the kernel config and dts i did which seem
to make the kernel on this device behave more reliable (it now works most of the time, but
i think the problems are not completely gone) - i just wanted to document those changes
somewhere in case this is helpful for someone else with a similarly broken device - the
changes are:

- changed-kernel-config.txt - disable cpuidle (looks like this maybe helped most)
- disable-fast-mmc.diff - disable the faster mmc modes (seems to result in less mmc errors at boot)
- disable-high-opp-points.txt - lower the max frequency of the cpu cores

some more notes:
- even before the changes the device was running stable once it booted up properly
- i tried several things like updating the ec firmware etc. but nothing else really helped
