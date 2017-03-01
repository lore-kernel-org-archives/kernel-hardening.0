From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 02 Mar 2017 00:14:51 +0100
MIME-Version: 1.0
Message-ID: <58B755EB.29911.B909EA3@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJDUgPDYduR0pZ14vNO2pXpFgwEG6SZhPOjyUQBt+Oi_g@mail.gmail.com>
References: <20170301203349.GA42365@beast>, <CAGXu5jKQEAFa33jn9eRzq1YS+RtMSWNBTSsk-u3fKqyr_zSR_A@mail.gmail.com>, <CAGXu5jJDUgPDYduR0pZ14vNO2pXpFgwEG6SZhPOjyUQBt+Oi_g@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] PCI: Fix typo in pax_open/close_kernel wrapping
To: Kees Cook <keescook@chromium.org>
Cc: Brad Spengler <spender@grsecurity.net>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 1 Mar 2017 at 14:58, Kees Cook wrote:

> >> are you sure you're looking at a recent tree?
> >
> > I guess not! Sorry for the noise. This was from pax-linux-4.9.9-test3.patch.
> 
> Actually, it looks like it's an error in the grsecurity merge of PaX.
> The mistake is present in the current grsecurity testing patch:
> https://grsecurity.net/test/grsecurity-3.1-4.9.13-201702270729.patch

he doesn't take such low priority fixes immediately (i found this regression
myself only a few days ago during the 4.10 port) but collects a few more of
them before making a new release.
