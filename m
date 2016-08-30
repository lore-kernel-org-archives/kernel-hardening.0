Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.DEB.2.10.1608281509480.3321@hadrien>
References: <alpine.DEB.2.10.1608272058090.3363@hadrien> <1472325098.26978.14.camel@perches.com>
 <alpine.DEB.2.10.1608281509480.3321@hadrien>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 Aug 2016 14:50:36 -0400
Message-ID: <CAGXu5jKZrHEZqyby-Gjrx=wjjCPw-kmkYBcW--+J5Y3w5QwNbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: constification and cocci / kernel build test robot ?
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Glenn Wurster <gwurster@blackberry.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Aug 28, 2016 at 9:13 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> [Adding Kees, in case it's of interest]
>
> Below is the list of types of top-level initialized structures and the
> number that are const.  For quicker reading, here are some that are
> sometimes const (numerator), but not always (denominator):
>
> file_operations: 2221/2233
> attribute_group: 447/919
> irq_chip: 1/518
> net_device_ops: 488/498
> regmap_config: 407/447
> dev_pm_ops: 398/415
> clk_ops: 314/386
> resource: 6/385
> seq_operations: 327/328
> snd_pcm_ops: 9/288
>
> and here are the most used ones that are never const at all:
>
> platform_driver: 2943
> platform_device: 2226
> clk_branch: 1131
> i2c_driver: 786
> pci_driver: 781
> omap_hwmod_ocp_if: 670
> omap_hwmod: 582
> notifier_block: 556
> clk: 473
> clk_rcg2: 384
>
> [...]

The structures that should get the greatest level of attention are
those that contain function pointers. The "constify" gcc plugin from
PaX/Grsecurity does this, but it uses a big hammer: it moves all of
them const even if they receive assignment. To handle this, there is
the concept of an open/close method to gain temporary access to the
structure. For example:

drivers/cdrom/cdrom.c:

int register_cdrom(...) {
        ...
        if (!cdo->generic_packet) {
                pax_open_kernel();
                const_cast(cdo->generic_packet) = cdrom_dummy_generic_packet;
                pax_close_kernel();
        }

(The "const_cast" here is just a macro to convince gcc it's only to
write to a const value, so really it should maybe be called
"unconst_cast", but whatever...)

This allows all of struct cdrom_device_ops to be const, even if they
need to be updated once during registration.

(This is a stronger version of __ro_after_init, which is for things
that are only written during __init.)

AUIU, the goals of the open/close_kernel idea are:
- always inline
- make sure the CPU cannot be interrupted
- BUG if memory is already writable
- make the memory writable only by the current CPU
- update the value
- restore memory permissions
- allow CPU interruption again

This makes sure there aren't races with other CPUs to write things,
and that it's harder to use for an attack since with the "make
writable" code is always followed by a "make read-only" action (i.e.
not separate functions that could be used as a trivial ROP gadget).

-Kees

-- 
Kees Cook
Nexus Security
