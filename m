Reply-To: kernel-hardening@lists.openwall.com
References: <564EF64F.1060903@redhat.com>
 <CAGXu5jLK61OFfSXtEzisMkdt9CnVaa5Eiw6sUB0=w2DjzPjJ5A@mail.gmail.com>
 <5654CE83.3000503@redhat.com>
 <CAGXu5j+zRXuiTipU=6VVoxacsYWcjhaax4gVbGRXteLihXVdOQ@mail.gmail.com>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <5665A94C.6060102@redhat.com>
Date: Mon, 7 Dec 2015 16:44:12 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+zRXuiTipU=6VVoxacsYWcjhaax4gVbGRXteLihXVdOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] System call interface changes
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/24/2015 10:43 PM, Kees Cook wrote:

> Cool. Well, we can certainly look at existing public exploits and
> PoCs. That's what I've been trying to collect on the Kernel
> Self-Protection Project wiki pages. There are plenty of things we
> could add to that list from the ROP world. Maybe it'd be good to look
> through various exploit lists to find stuff that use techniques that
> are either missing from the wiki page or are better examples? Do you
> (or someone else) have time to go on a research/collection exercise?

The proposal I have (and which prompted the question about the system
call interface) is to block execve because many proof-of-concept exploit
use execve or system to spawn a shell or run arbitrary commands.

But I'm concerned that it's basically the same thing Yves-Alexis mention
in the discussion about commit_creds(prepare_creds(0)):

  <http://www.openwall.com/lists/kernel-hardening/2015/11/26/8>

So execve is perhaps just a demo, just like running CALC.EXE on Windows.
 I'm worried that execve blocking is a bit like renaming CALC.EXE in
terms of impact regarding actual successful compromises, that is, it
won't make a difference.

In terms of actual impact on compromised Linux servers, SAML support in
FTP, OpenSSH and sudo, combined with popular Windows clients that can
interoperate (I don't know if people still use WinSCP) would probably
reduce compromises due to leaked credentials substantially.  My hunch is
that such compromises (even delayed reuse of credentials) cover by far
the largest number of server compromises.  But this is an extremely
high-level issue—we are basically providing mitigation for a client-side
issue, where we don't control the client at all.  And large scale web
hosters primarily affected by this do not approach us with such
requirements, as far as I know.

Florian
