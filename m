Reply-To: kernel-hardening@lists.openwall.com
References: <564EF64F.1060903@redhat.com>
 <CAGXu5jLK61OFfSXtEzisMkdt9CnVaa5Eiw6sUB0=w2DjzPjJ5A@mail.gmail.com>
 <5654CE83.3000503@redhat.com>
 <CAGXu5j+zRXuiTipU=6VVoxacsYWcjhaax4gVbGRXteLihXVdOQ@mail.gmail.com>
 <5665A94C.6060102@redhat.com>
From: lazytyped <lazytyped@gmail.com>
Message-ID: <5665B344.6030706@gmail.com>
Date: Mon, 7 Dec 2015 17:26:44 +0100
MIME-Version: 1.0
In-Reply-To: <5665A94C.6060102@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] System call interface changes
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 12/7/15 4:44 PM, Florian Weimer wrote:
> On 11/24/2015 10:43 PM, Kees Cook wrote:
>
>> Cool. Well, we can certainly look at existing public exploits and
>> PoCs. That's what I've been trying to collect on the Kernel
>> Self-Protection Project wiki pages. There are plenty of things we
>> could add to that list from the ROP world. Maybe it'd be good to look
>> through various exploit lists to find stuff that use techniques that
>> are either missing from the wiki page or are better examples? Do you
>> (or someone else) have time to go on a research/collection exercise?
> The proposal I have (and which prompted the question about the system
> call interface) is to block execve because many proof-of-concept exploit
> use execve or system to spawn a shell or run arbitrary commands.
So just drop that privilege? Pretty much any operating system implements
a form of sandboxing/privilege/capability filtering. It's, of course,
application specific.

Keep in mind that blocking execve leaves open chown(), chmod(), mount()
and a large number of other system calls that can be leveraged to
achieve a similar result.


     -  twiz
