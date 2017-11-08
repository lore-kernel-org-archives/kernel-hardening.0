Date: Wed, 8 Nov 2017 12:13:48 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171108011348.GY18478@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com>
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Laura Abbott <labbott@redhat.com>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 07, 2017 at 03:36:06PM -0800, Laura Abbott wrote:
> On 11/07/2017 02:32 AM, Tobin C. Harding wrote:
> >Currently we are leaking addresses from the kernel to user space. This
> >script is an attempt to find some of those leakages. Script parses
> >`dmesg` output and /proc and /sys files for hex strings that look like
> >kernel addresses.
> >
> >Only works for 64 bit kernels, the reason being that kernel addresses
> >on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> >possible. On 32 kernels we don't have this luxury.
> >
> >Scripts is _slightly_ smarter than a straight grep, we check for false
> >positives (all 0's or all 1's, and vsyscall start/finish addresses).
> >
> >Output is saved to file to expedite repeated formatting/viewing of
> >output.
> >
> >Signed-off-by: Tobin C. Harding <me@tobin.cc>
> >---
> >
> >This version outputs a report instead of the raw results by default. Designing
> >this proved to be non-trivial, the reason being that it is not immediately clear
> >what constitutes a duplicate entry (similar message, address range, same
> >file?). Also, the aim of the report is to assist users _not_ missing correct
> >results; limiting the output is inherently a trade off between noise and
> >correct, clear results.
> >
> >Without testing on various real kernels its not clear that this reporting is any
> >good, my test cases were a bit contrived. Your usage may vary.
> >
> >It would be super helpful to get some comments from people running this with
> >different set ups.
> >
> 
> Running on a stock Fedora kernel with gnome generates a 139M file.
> I'll admit that Fedora is pretty generous in what it enables.
> Trimmed down to omit some redundancies in various processes
> by only printing off of the last file in the path
> 
> /proc/kallsyms
> /proc/modules
> /proc/timer_list
> /proc/1244/stack
> /proc/4041/status
> /proc/bus/input/devices <--- Probably a false positive
> /proc/1/net/hci
> /proc/1/net/tcp
> /proc/1/net/udp
> /proc/1/net/bnep
> /proc/1/net/raw6
> /proc/1/net/tcp6
> /proc/1/net/udp6
> /proc/1/net/unix
> /proc/1/net/l2cap
> /proc/1/net/packet
> /proc/1/net/rfcomm
> /proc/1/net/netlink
> /sys/module/snd_compress/sections/.note.gnu.build-id
> /sys/module/snd_compress/sections/.exit.text
> /sys/module/snd_compress/sections/__mcount_loc
> /sys/module/snd_compress/sections/__ksymtab_strings
> /sys/module/snd_compress/sections/__ksymtab_gpl
> /sys/module/snd_compress/sections/.init.text
> /sys/module/snd_compress/sections/.gnu.linkonce.this_module
> /sys/module/snd_compress/sections/__jump_table
> /sys/module/snd_compress/sections/.strtab
> /sys/module/snd_compress/sections/.bss
> /sys/module/snd_compress/sections/.rodata.str1.1
> /sys/module/snd_compress/sections/__bug_table
> /sys/module/snd_compress/sections/__verbose
> /sys/module/snd_compress/sections/.rodata.str1.8
> /sys/module/snd_compress/sections/.text
> /sys/module/snd_compress/sections/.data
> /sys/module/snd_compress/sections/.symtab
> /sys/module/snd_compress/sections/.rodata
> /sys/module/iwlmvm/sections/.altinstr_replacement
> /sys/module/iwlmvm/sections/.altinstructions
> /sys/module/iwlmvm/sections/.data.unlikely
> /sys/module/iwlmvm/sections/__param
> /sys/module/iwlmvm/sections/.smp_locks
> /sys/module/snd_hda_intel/sections/__tracepoints_ptrs
> /sys/module/snd_hda_intel/sections/__tracepoints
> /sys/module/snd_hda_intel/sections/__tracepoints_strings
> /sys/module/snd_hda_intel/sections/_ftrace_events
> /sys/module/snd_hda_intel/sections/.ref.data
> /sys/module/iwlwifi/sections/.parainstructions
> /sys/module/iwlwifi/sections/__ksymtab
> /sys/module/uvcvideo/sections/.fixup
> /sys/module/uvcvideo/sections/.text.unlikely
> /sys/module/uvcvideo/sections/__ex_table
> /sys/module/intel_powerclamp/sections/.init.rodata
> /sys/module/mac80211/sections/.data..read_mostly
> /sys/module/nfnetlink/sections/.init.data
> /sys/module/ghash_clmulni_intel/sections/.rodata.cst16.bswap_mask
> /sys/module/videodev/sections/_ftrace_eval_map
> /sys/module/kvm_intel/sections/.data..ro_after_init
> /sys/module/kvm_intel/sections/.altinstr_aux
> /sys/module/crct10dif_pclmul/sections/.rodata.cst16.SHUF_MASK
> /sys/module/crct10dif_pclmul/sections/.rodata.cst16.mask1
> /sys/module/crct10dif_pclmul/sections/.rodata.cst32.pshufb_shf_table
> /sys/module/crct10dif_pclmul/sections/.rodata.cst16.mask2
> /sys/module/nf_conntrack/sections/.data..cacheline_aligned
> /sys/firmware/efi/runtime-map/5/virt_addr
> /sys/devices/platform/i8042/serio0/input/input3/uevent
> /sys/devices/platform/i8042/serio0/input/input3/capabilities/key

thanks for running the script. Is there any chance you could email me
the complete output please? The next patch includes a flag to do
this. You can wait until that lands if it is easier for you.

thanks,
Tobin.
