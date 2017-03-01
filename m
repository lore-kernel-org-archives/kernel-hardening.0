MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <58B740E4.25691.B3E7B0D@pageexec.freemail.hu>
References: <20170301203349.GA42365@beast> <58B740E4.25691.B3E7B0D@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 1 Mar 2017 14:46:37 -0800
Message-ID: <CAGXu5jKQEAFa33jn9eRzq1YS+RtMSWNBTSsk-u3fKqyr_zSR_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] PCI: Fix typo in pax_open/close_kernel wrapping
To: PaX Team <pageexec@freemail.hu>
Cc: Brad Spengler <spender@grsecurity.net>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 1, 2017 at 1:45 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 1 Mar 2017 at 12:33, Kees Cook wrote:
>
>> This fixes a mistaken double-open in PaX's constification coverage of
>> cpcihp_zt5550.
>
> patch complains with:
>
>  checking file drivers/pci/hotplug/cpcihp_zt5550.c
>  Reversed (or previously applied) patch detected!  Assume -R? [n]
>
> are you sure you're looking at a recent tree?

I guess not! Sorry for the noise. This was from pax-linux-4.9.9-test3.patch.

-Kees

-- 
Kees Cook
Pixel Security
