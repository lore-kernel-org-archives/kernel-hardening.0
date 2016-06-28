Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 15:15:25 +0200
From: Marcus Meissner <meissner@suse.de>
Message-ID: <20160628131525.GB1255@suse.de>
References: <57138.1466998197@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57138.1466998197@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Usercopy caught another one - ping IPv6...
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is probably the ICMPV6_FILTER setting?

                if (optlen > sizeof(struct icmp6_filter))
		                        optlen = sizeof(struct icmp6_filter);
                if (copy_from_user(&raw6_sk(sk)->filter, optval, optlen))
		                        return -EFAULT;

struct raw6_sock has
        struct icmp6_filter     filter;

not sure where the bug is.

Ciao, Marcus

On Sun, Jun 26, 2016 at 11:29:57PM -0400, Valdis Kletnieks wrote:
> usercopy kills attempts to use ping....
> 
> (Kernel tainted by a probably unrelated MMC issue)
> 
> [135768.173443] usercopy: kernel memory overwrite attempt detected to ffff8800be26fd90 (RAWv6) (32 bytes)
> [135768.173451] CPU: 3 PID: 56577 Comm: ping Tainted: G      D    OE   4.7.0-rc3-next-20160614-dirty #302
> [135768.173453] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
> [135768.173455]  0000000000000000 000000004951b1ca ffff880223687e10 ffffffffb169f61a
> [135768.173459]  ffff8800be26fd90 000000004951b1ca 0000000000000020 0000000000000000
> [135768.173463]  ffff880223687e60 ffffffffb1367b30 0000000000000001 ffffea0002998868
> [135768.173467] Call Trace:
> [135768.173473]  [<ffffffffb169f61a>] dump_stack+0x7b/0xd1
> [135768.173476]  [<ffffffffb1367b30>] __check_object_size+0x70/0x3d4
> [135768.173479]  [<ffffffffb1ded6bb>] compat_rawv6_setsockopt.part.11+0x4b/0x80
> [135768.173482]  [<ffffffffb1ded824>] rawv6_setsockopt+0x84/0xb0
> [135768.173485]  [<ffffffffb15c66c5>] ? selinux_socket_setsockopt+0x45/0x60
> [135768.173488]  [<ffffffffb1bd1d0a>] sock_common_setsockopt+0x3a/0xc0
> [135768.173490]  [<ffffffffb1bcfb99>] SyS_setsockopt+0x89/0x120
> [135768.173493]  [<ffffffffb20896e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
> [135768.173497]  [<ffffffffb1143e3f>] ? trace_hardirqs_off_caller+0x1f/0xf0
> 



-- 
Marcus Meissner,SUSE LINUX GmbH; Maxfeldstrasse 5; D-90409 Nuernberg; Zi. 3.1-33,+49-911-740 53-432,,serv=loki,mail=wotan,type=real <meissner@suse.de>
