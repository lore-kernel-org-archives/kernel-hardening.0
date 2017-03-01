From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 01 Mar 2017 22:45:08 +0100
MIME-Version: 1.0
Message-ID: <58B740E4.25691.B3E7B0D@pageexec.freemail.hu>
In-reply-to: <20170301203349.GA42365@beast>
References: <20170301203349.GA42365@beast>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] PCI: Fix typo in pax_open/close_kernel wrapping
To: Kees Cook <keescook@chromium.org>
Cc: spender@grsecurity.net, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 1 Mar 2017 at 12:33, Kees Cook wrote:

> This fixes a mistaken double-open in PaX's constification coverage of
> cpcihp_zt5550.

patch complains with:

 checking file drivers/pci/hotplug/cpcihp_zt5550.c
 Reversed (or previously applied) patch detected!  Assume -R? [n]

are you sure you're looking at a recent tree?
