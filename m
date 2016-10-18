Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161018131300.GM14666@pc.thejh.net>
References: <58061416.7020209@oracle.com> <20161018131300.GM14666@pc.thejh.net>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Tue, 18 Oct 2016 18:56:24 -0400
Message-ID: <CACXcFmnOjbxXf9ek2mwgyYSXvf=aUY5FcOsgNC8GbA2at=D9tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Use-after-free and management of reference counts
To: kernel-hardening@lists.openwall.com
Cc: Vaishali Thakkar <vaishali.thakkar@oracle.com>, Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 9:13 AM, Jann Horn <jann@thejh.net> wrote:

> Use-after-frees are really hard to deal with.

I want to ask a possibly naive questions -- why can't we avoid the
whole class of bugs in the first place? I can think of only two main
sources for use-after-free bugs, both avoidable.

One is allocating something within a function, then returning a
pointer to it. I know I've done that on occasion, got a warning from
lint(1) or the compiler, & fixed it; I have forgotten details. Surely
current static analysis tools can catch nearly all of these. If not,
writing one looks fairly straightforward. Sure, complex code with a
lot of indirection might fool such tools, but in general such code
should not be used anyway.

The other is misusing malloc()/free() or their kernel code analogs, &
the obvious solution is to avoid using those wherever possible. There
are some kernel data structures that need to grow dynamically, but I
do not think there need to be a lot. Code the few very carefully and
refuse to accept patches elsewhere that use dynamic allocation; the
problem may not vanish, but it looks like this reduces it to
manageable size.

I have the feeling I might be missing something here. Pointers welcome.
