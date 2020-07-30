Return-Path: <SRS0=MzfV=BJ=lists.openwall.com=kernel-hardening-return-19494-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E364FC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 14:25:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DEF12208A9
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 14:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HmFBOydR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEF12208A9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19494-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1205 invoked by uid 550); 30 Jul 2020 14:25:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1185 invoked from network); 30 Jul 2020 14:25:10 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D7FE220B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1596119098;
	bh=oE+7KaFfrAvOJfWAz0jMfT0sMmkx+qq0QNiYXLIBvZ8=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=HmFBOydRYvQk4vL6AnxS7chJxWGw+ORn/V7uofOrwvmgVBKl5U45zA83kecsLk2fo
	 L/lpQlJAi0fioAtM/eHUJ7sWl4YMSscWZRf2476MGrBlyOOavjzo0qKT1XwcNLd6ej
	 n1ffJHonAv4WWSBjzxWYXjj8EYeKFG0ECseZ5zKY=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
Date: Thu, 30 Jul 2020 09:24:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
Content-Type: multipart/alternative;
 boundary="------------8126E1E1A7B2A73B271E67E2"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------8126E1E1A7B2A73B271E67E2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Sorry for the delay. I just wanted to think about this a little.
In this email, I will respond to your first suggestion. I will
respond to the rest in separate emails if that is alright with
you.

On 7/28/20 12:31 PM, Andy Lutomirski wrote:
>> On Jul 28, 2020, at 6:11 AM, madvenka@linux.microsoft.com wrote:
>>
>> ﻿From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The kernel creates the trampoline mapping without any permissions. When
>> the trampoline is executed by user code, a page fault happens and the
>> kernel gets control. The kernel recognizes that this is a trampoline
>> invocation. It sets up the user registers based on the specified
>> register context, and/or pushes values on the user stack based on the
>> specified stack context, and sets the user PC to the requested target
>> PC. When the kernel returns, execution continues at the target PC.
>> So, the kernel does the work of the trampoline on behalf of the
>> application.
> This is quite clever, but now I’m wondering just how much kernel help
> is really needed. In your series, the trampoline is an non-executable
> page.  I can think of at least two alternative approaches, and I'd
> like to know the pros and cons.
>
> 1. Entirely userspace: a return trampoline would be something like:
>
> 1:
> pushq %rax
> pushq %rbc
> pushq %rcx
> ...
> pushq %r15
> movq %rsp, %rdi # pointer to saved regs
> leaq 1b(%rip), %rsi # pointer to the trampoline itself
> callq trampoline_handler # see below
>
> You would fill a page with a bunch of these, possibly compacted to get
> more per page, and then you would remap as many copies as needed.  The
> 'callq trampoline_handler' part would need to be a bit clever to make
> it continue to work despite this remapping.  This will be *much*
> faster than trampfd. How much of your use case would it cover?  For
> the inverse, it's not too hard to write a bit of asm to set all
> registers and jump somewhere.

Let me state what I have understood about this suggestion. Correct me if
I get anything wrong. If you don't mind, I will also take the liberty
of generalizing and paraphrasing your suggestion.

The goal is to create two page mappings that are adjacent to each other:

	- a code page that contains template code for a trampoline. Since the
	  template code would tend to be small in size, pack as many of them
	  as possible within a page to conserve memory. In other words, create
	  an array of the template code fragments. Each element in the array
	  would be used for one trampoline instance.

	- a data page that contains an array of data elements. Corresponding
	  to each code element in the code page, there would be a data element
	  in the data page that would contain data that is specific to a
	  trampoline instance.

	- Code will access data using PC-relative addressing.

The management of the code pages and allocation for each trampoline
instance would all be done in user space.

Is this the general idea?

Creating a code page
--------------------

We can do this in one of the following ways:

- Allocate a writable page at run time, write the template code into
  the page and have execute permissions on the page.

- Allocate a writable page at run time, write the template code into
  the page and remap the page with just execute permissions.

- Allocate a writable page at run time, write the template code into
  the page, write the page into a temporary file and map the file with
  execute permissions.

- Include the template code in a code page at build time itself and
  just remap the code page each time you need a code page.

Pros and Cons
-------------

As long as the OS provides the functionality to do this and the security
subsystem in the OS allows the actions, this is totally feasible. If not,
we need something like trampfd.

As Floren mentioned, libffi does implement something like this for MACH.

In fact, in my libffi changes, I use trampfd only after all the other methods
have failed because of security settings.

But the above approach only solves the problem for this simple type of
trampoline. It does not provide a framework for addressing more complex types
or even other forms of dynamic code.

Also, each application would need to implement this solution for itself
as opposed to relying on one implementation provided by the kernel.

Trampfd-based solution
----------------------

I outlined an enhancement to trampfd in a response to David Laight. In this
enhancement, the kernel is the one that would set up the code page.

The kernel would call an arch-specific support function to generate the
code required to load registers, push values on the stack and jump to a PC
for a trampoline instance based on its current context. The trampoline
instance data could be baked into the code.

My initial idea was to only have one trampoline instance per page. But I
think I can implement multiple instances per page. I just have to manage
the trampfd file private data and VMA private data accordingly to map an
element in a code page to its trampoline object.

The two approaches are similar except for the detail about who sets up
and manages the trampoline pages. In both approaches, the performance problem
is addressed. But trampfd can be used even when security settings are
restrictive.

Is my solution acceptable?

A couple of things
------------------

- In the current trampfd implementation, no physical pages are actually
  allocated. It is just a virtual mapping. From a memory footprint
  perspective, this is good. May be, we can let the user specify if
  he wants a fast trampoline that consumes memory or a slow one that
  doesn't?

- In the future, we may define additional types that need the kernel to do
  the job. Examples:

	- The kernel may have a trampoline type for which it is not willing
	  or able to generate code
	- The kernel could emulate dynamic code for the user
	- The kernel could interpret dynamic code for the user
	- The kernel could allow the user to access some kernel
	  functionality using the framework

  In such cases, there isn't any physical code page that gets mapped into
  the user address space. We need the kernel to handle the address fault
  cases and provide the functionality.

One question for the reviewers
------------------------------

Do you think that the file descriptor based approach is fine? Or, does this
need a regular system call based implementation? There are some advantages
with a regular system call:

	- We don't consume file descriptors. E.g., in libffi, we have to
	  keep the file descriptor open for a closure until the closure
	  is freed.

	- Trampoline operations can be performed based on the trampoline
	  address instead of an fd.

	- Sharing of objects across processes can be implemented through
	  a regular ID based method rather than sending the file descriptor
	  over a unix domain socket.

	- Shared objects can be persistent.

	- An fd based API does structure parsing in read()/write() calls
	  to obtain arguments. With a regular system call, that is not
	  necessary.

Please let me know your thoughts.

Madhavan


--------------8126E1E1A7B2A73B271E67E2
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    Sorry for the delay. I just wanted to think about this a little.<br>
    In this email, I will respond to your first suggestion. I will<br>
    respond to the rest in separate emails if that is alright with<br>
    you.<br>
    <br>
    <div class="moz-cite-prefix">On 7/28/20 12:31 PM, Andy Lutomirski
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com">
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">On Jul 28, 2020, at 6:11 AM, <a class="moz-txt-link-abbreviated" href="mailto:madvenka@linux.microsoft.com">madvenka@linux.microsoft.com</a> wrote:

﻿From: "Madhavan T. Venkataraman" <a class="moz-txt-link-rfc2396E" href="mailto:madvenka@linux.microsoft.com">&lt;madvenka@linux.microsoft.com&gt;</a>

</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">The kernel creates the trampoline mapping without any permissions. When
the trampoline is executed by user code, a page fault happens and the
kernel gets control. The kernel recognizes that this is a trampoline
invocation. It sets up the user registers based on the specified
register context, and/or pushes values on the user stack based on the
specified stack context, and sets the user PC to the requested target
PC. When the kernel returns, execution continues at the target PC.
So, the kernel does the work of the trampoline on behalf of the
application.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
This is quite clever, but now I’m wondering just how much kernel help
is really needed. In your series, the trampoline is an non-executable
page.  I can think of at least two alternative approaches, and I'd
like to know the pros and cons.

1. Entirely userspace: a return trampoline would be something like:

1:
pushq %rax
pushq %rbc
pushq %rcx
...
pushq %r15
movq %rsp, %rdi # pointer to saved regs
leaq 1b(%rip), %rsi # pointer to the trampoline itself
callq trampoline_handler # see below

You would fill a page with a bunch of these, possibly compacted to get
more per page, and then you would remap as many copies as needed.  The
'callq trampoline_handler' part would need to be a bit clever to make
it continue to work despite this remapping.  This will be *much*
faster than trampfd. How much of your use case would it cover?  For
the inverse, it's not too hard to write a bit of asm to set all
registers and jump somewhere.
</pre>
    </blockquote>
    <pre style="color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; overflow-wrap: break-word; white-space: pre-wrap;">
Let me state what I have understood about this suggestion. Correct me if
I get anything wrong. If you don't mind, I will also take the liberty
of generalizing and paraphrasing your suggestion.

The goal is to create two page mappings that are adjacent to each other:

	- a code page that contains template code for a trampoline. Since the
	  template code would tend to be small in size, pack as many of them
	  as possible within a page to conserve memory. In other words, create
	  an array of the template code fragments. Each element in the array
	  would be used for one trampoline instance.

	- a data page that contains an array of data elements. Corresponding
	  to each code element in the code page, there would be a data element
	  in the data page that would contain data that is specific to a
	  trampoline instance.

	- Code will access data using PC-relative addressing.

The management of the code pages and allocation for each trampoline
instance would all be done in user space.

Is this the general idea?

Creating a code page
--------------------

We can do this in one of the following ways:

- Allocate a writable page at run time, write the template code into
  the page and have execute permissions on the page.

- Allocate a writable page at run time, write the template code into
  the page and remap the page with just execute permissions.

- Allocate a writable page at run time, write the template code into
  the page, write the page into a temporary file and map the file with
  execute permissions.

- Include the template code in a code page at build time itself and
  just remap the code page each time you need a code page.

Pros and Cons
-------------

As long as the OS provides the functionality to do this and the security
subsystem in the OS allows the actions, this is totally feasible. If not,
we need something like trampfd.

As Floren mentioned, libffi does implement something like this for MACH.

In fact, in my libffi changes, I use trampfd only after all the other methods
have failed because of security settings.

But the above approach only solves the problem for this simple type of
trampoline. It does not provide a framework for addressing more complex types
or even other forms of dynamic code.

Also, each application would need to implement this solution for itself
as opposed to relying on one implementation provided by the kernel.

Trampfd-based solution
----------------------

I outlined an enhancement to trampfd in a response to David Laight. In this
enhancement, the kernel is the one that would set up the code page.

The kernel would call an arch-specific support function to generate the
code required to load registers, push values on the stack and jump to a PC
for a trampoline instance based on its current context. The trampoline
instance data could be baked into the code.

My initial idea was to only have one trampoline instance per page. But I
think I can implement multiple instances per page. I just have to manage
the trampfd file private data and VMA private data accordingly to map an
element in a code page to its trampoline object.

The two approaches are similar except for the detail about who sets up
and manages the trampoline pages. In both approaches, the performance problem
is addressed. But trampfd can be used even when security settings are
restrictive.

Is my solution acceptable?

A couple of things
------------------

- In the current trampfd implementation, no physical pages are actually
  allocated. It is just a virtual mapping. From a memory footprint
  perspective, this is good. May be, we can let the user specify if
  he wants a fast trampoline that consumes memory or a slow one that
  doesn't?

- In the future, we may define additional types that need the kernel to do
  the job. Examples:

	- The kernel may have a trampoline type for which it is not willing
	  or able to generate code
	- The kernel could emulate dynamic code for the user
	- The kernel could interpret dynamic code for the user
	- The kernel could allow the user to access some kernel
	  functionality using the framework

  In such cases, there isn't any physical code page that gets mapped into
  the user address space. We need the kernel to handle the address fault
  cases and provide the functionality.

One question for the reviewers
------------------------------

Do you think that the file descriptor based approach is fine? Or, does this
need a regular system call based implementation? There are some advantages
with a regular system call:

	- We don't consume file descriptors. E.g., in libffi, we have to
	  keep the file descriptor open for a closure until the closure
	  is freed.

	- Trampoline operations can be performed based on the trampoline
	  address instead of an fd.

	- Sharing of objects across processes can be implemented through
	  a regular ID based method rather than sending the file descriptor
	  over a unix domain socket.

	- Shared objects can be persistent.

	- An fd based API does structure parsing in read()/write() calls
	  to obtain arguments. With a regular system call, that is not
	  necessary.

Please let me know your thoughts.

Madhavan</pre>
  </body>
</html>

--------------8126E1E1A7B2A73B271E67E2--
