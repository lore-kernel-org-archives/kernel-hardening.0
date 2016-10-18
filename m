Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <58061416.7020209@oracle.com>
References: <58061416.7020209@oracle.com>
From: David Windsor <dave@progbits.org>
Date: Tue, 18 Oct 2016 09:11:46 -0400
Message-ID: <CAEXv5_hPpRwNaryqRQ8i3-2q9+Yqa6yWPF_QMYzQFOs8AdCkrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Use-after-free and management of reference counts
To: kernel-hardening@lists.openwall.com
Cc: Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Oct 18, 2016 at 8:22 AM, Vaishali Thakkar
<vaishali.thakkar@oracle.com> wrote:
> Hi,
>
> Recently I studied the reported CVEs of last 2 years and there were
> fair number of use-after-free bugs. Usually we also see many reports
> of use-after-free bugs in the LKML [reported by one or other tools].
>
> Also, at Kernel recipes Jonathan Corbet  mentioned reference counts as
> a security issue. I believe if we have more kernel hardening patches
> then we can avoid such bugs. I was wondering if there is some ongoing
> work in the both [use-after-free and management of reference counts]
> of these areas?
>

There is a patchset currently on this mailing list (kernel-hardening)
that directly addresses use-after free bugs.  The feature is called
HARDENED_ATOMIC and is based off of earlier work done by PaX
(https://forums.grsecurity.net/viewtopic.php?f=7&t=4173).

Here is a link to the feature's latest RFC patchset:
http://www.openwall.com/lists/kernel-hardening/2016/10/03/1

Here is the work we've done thus far in documenting the feature:
http://progbits.org

If you're interested in helping with this feature, we're always
looking for people to help move the feature to other architectures.
Someone else is already working on the arm64 port, so you may want to
look at either arm (this is most preferable), mips, sparc or powerpc.
You may want to talk to Takahiro Akashi, who is doing the arm64 work,
to get his thoughts on the arm port.  See this thread for more
information: http://www.openwall.com/lists/kernel-hardening/2016/10/12/2.

> If not, then I would like to work on the same. Any pointers on this
> would be appreciated.
>

Great, thanks for offering to help!  Let me know if you'd like any
other pointers.

> Thank you.
>
> --
> Vaishali
