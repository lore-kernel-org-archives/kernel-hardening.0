Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <29498.1447107624@turing-police.cc.vt.edu>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org>
	<87h9kvze0o.fsf@rasmusvillemoes.dk>
	<20151109103315.GB19735@chrystal.uk.oracle.com>
	<87bnb3ou1c.fsf@rasmusvillemoes.dk>
	<CAGXu5jLST1eoNU3YF-kLnTOHcq6iyD8YbS=oGr+3p2eFsz-X=A@mail.gmail.com>
	<c3c5f9857a782b1d4405272f08ce5b3d@opensec.fr>
	<29498.1447107624@turing-police.cc.vt.edu>
Date: Mon, 9 Nov 2015 15:33:20 -0800
Message-ID: <CAGXu5jKwuuQ3=CC+ZPqP0B0pLD6R99EDE5k_sNdiQp4gsMd7Kg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Binary blobs
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 9, 2015 at 2:20 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 09 Nov 2015 22:59:31 +0100, HacKurx said:
>> The binary blobs are a potential for undetectable or irreparable
>> security flaws (Andrews Jeremy "Interview: Theo de Raadt", KernelTrap).
>>
>> What is your point of view? Linux-libre kernel is the only reliable
>> basis?
>
> Closed source is by definition not easily examined for security issues (though
> once you get to monsters like LibreOffice or Firefox, even open source code
> is difficult to audit).
>
> The problem is that at the current time, not all software is easily opened. For
> example, the single biggest reason (among several) that NVidia has a binary
> blob driver is that (simplifying *drastically* here) when SGI's graphics
> division imploded, NVidia got all the engineers - but Microsoft snarfed up a
> bunch of patents connected to OpenGL.  So NVidia had no realistic choice but to
> license the intellectual property from Microsoft.
>
> So out in the real world, you have to look at your threat model, and decide
> how paranoid you are.  (Personally, I'd be more worried about the open-sourced
> Firefox code than I would the NVidia binary blob.  The former has got a *huge*
> attack surface compared to the latter....)

I think the first step is making sure you know _what_ blobs you're
loading, and to have a known list of them. (There are efforts started
with signed firmware[1] validation or the loadpin[2] LSM -- though
neither yet deal with userspace loaded blobs like graphics drivers,
SSD firmware, etc). This would block having blobs be manipulated
maliciously before they're loaded. After that mechanism is in place,
then it'd be useful to reverse engineer them to find security flaws.

-Kees

[1] http://lists.linuxfoundation.org/pipermail/ksummit-discuss/2015-August/002238.html
[2] http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=lsm/loadpin

-- 
Kees Cook
Chrome OS Security
