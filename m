Return-Path: <kernel-hardening-return-21956-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 08582C87FD3
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Aug 2025 10:47:23 +0000 (UTC)
Received: (qmail 5167 invoked by uid 550); 8 Aug 2025 10:47:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4088 invoked from network); 8 Aug 2025 10:47:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754650023; x=1755254823; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T/9tDEacu9UlvMURMVhrDf6nZJFdlhByYvHn1E0d6ts=;
        b=qLO1rMbGhk+V3mpZ2r2VUTLQSdQXi0Zwxg9+R9FI5TIhIrG8vqI19SKaAk2bbFCnEQ
         aAyWkZEL34EbXa+cttmgnBpWpScBrjnf87Jq+ZSN+QpsP3skYofTi24ATWyF8IOxtwFi
         ++U/uhMLI8y28p0TXs7qtJ0BpVDB9EmUNwxzrN0zFwNW+gqVlr9Suz2lGjOonF+CYl+g
         5QU+uMxgUCHlr2vd8Wey17h2IbLOOop/T5LRE/1Rg5ata3abIt3YnMNQ+J6BFB4zF8yA
         gDm0zG4THNL55EX+mCUW/d8VbifdPmRhUdCGOHjBVvFxCa2VCmIdo/bozg1dTtrxVH7T
         6QGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754650023; x=1755254823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/9tDEacu9UlvMURMVhrDf6nZJFdlhByYvHn1E0d6ts=;
        b=R4h+/SBAabHVg5kLrbcheOkzGBiuwIim12THmyc8U1ZjrhOWBIptKyjTGYbHq0yRSq
         UXKhk35yHPuzKCfB+kxzaXHHGoAgtALNq/JheBt+M6hHF4T/oVnbb0kcfBZo/pP6dDPc
         SxUUsbZM1rb0W8olStp8Rf+SDNZ5OVt/kz/dqGZayxAE2D0zxNjWC1duGPrezW1aXMWQ
         8312KBnB1tIZRceXxhY+1OCZZac0mMe1rjkDZAI5nyxyd1/F/fvZ8Cy8ikEq64djR8ZN
         EfXjpF4UOJgvTizLWPhorwjo73Nw+mrFBke/J8yJU0IpxQ15dzy9cYV/nTCSnuAR5xfl
         paBg==
X-Gm-Message-State: AOJu0Yy/sAys+oy+ymZigS/ULcZnmFUcgbYsTefTPLSzejoEl/tztOJV
	K433oHqVS1TlcQE4C2LyY8ehFpYuhU6ndTMVNqTS6ZsG43Sso2U5eGiny7m5FfmoWblRnFcHNsY
	KqPfl4sjEdl5zbCQtiPXhaV/PkGnG6wID28slCEsHqVMbGiZV4jMNjIjd
X-Gm-Gg: ASbGnctivU9aMUo7460GvUOl0xsvOjzGNo9B+HXMX/XOv1w9Hz0AFVjXEabUTdNymK5
	3JEYmzjAvF1ee6HiPvHav7Pna3Ql2kn976XjfwUpQXUbzfMrkv0Y7a6Ei1D3zIRkY6O0eLqYYDE
	D3HhAvFyIn7MOyFPKJHu1RBPAUWuBcxqLiuNJbK39fC1m3D+fHOo9oW2a+9RhaPlvlfeOXndf3n
	abhG3I86hSHgWxNj4zPGzISs5UXl/HEsQ==
X-Google-Smtp-Source: AGHT+IFqOmNnaK5hefSrnjtM0v0uNXgTRRJ7WOVrAmeMc2Mba23uf6PFMYJdn94b5J227yyK03JrXiS6iK15JVlPDHg=
X-Received: by 2002:a50:8ac9:0:b0:615:6167:4835 with SMTP id
 4fb4d7f45d1cf-617e4938cc5mr58598a12.7.1754650022459; Fri, 08 Aug 2025
 03:47:02 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Fri, 8 Aug 2025 12:46:26 +0200
X-Gm-Features: Ac12FXz5MNEBgvVXLpyOXJS0S3xY8nUmV94N9fcForngE0yiRR5U9n3XjTzYizU
Message-ID: <CAG48ez0ww6FhoidYcBzw-1LOSFr_OW=j5X7ch32Go1dgRo7e2A@mail.gmail.com>
Subject: abusing CONFIG_RANDOMIZE_KSTACK_OFFSET to assist with exploitation
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

I just published a blogpost
(https://googleprojectzero.blogspot.com/2025/08/from-chrome-renderer-code-e=
xec-to-kernel.html)
about how I wrote a kernel exploit that uses an AF_UNIX bug to go from
"attacker can run arbitrary native code in a sandboxed Chrome
renderer" to kernel page table control.

One aspect that I think I should call out in particular is that
CONFIG_RANDOMIZE_KSTACK_OFFSET was actually helpful for this exploit -
when I was at a point where I already had a (semi-)arbitrary read
primitive, I could use the combination of
CONFIG_RANDOMIZE_KSTACK_OFFSET and the read primitive to line up
things on the stack that would otherwise never have been in the right
spot.

Quoting two sections from my linked blogpost that are directly
relevant for CONFIG_RANDOMIZE_KSTACK_OFFSET:
<<<
## Finding a reallocation target: The magic of `CONFIG_RANDOMIZE_KSTACK_OFF=
SET`
[...] I went looking for some other allocation which would place an
object such that incrementing the value at address 0x...44 leads to a
nice primitive. It would be nice to have something there like an
important flags field, or a length specifying the size of a pointer
array, or something like that. I spent a lot of time looking at
various object types that can be allocated on the kernel heap from
inside the Chrome sandbox, but found nothing great.

Eventually, I realized that I had been going down the wrong path.
Clearly trying to target a heap object was foolish, because there is
something much better: It is possible to reallocate the target page as
the topmost page of a kernel stack!

That might initially sound like a silly idea; but Debian's kernel
config enables `CONFIG_RANDOMIZE_KSTACK_OFFSET=3Dy` and
`CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=3Dy`, **causing each syscall
invocation to randomly shift the stack pointer down by up to 0x3f0
bytes, with 0x10 bytes granularity**. That is supposed to be a
security mitigation, but works to my advantage when I already have an
arbitrary read: instead of having to find an overwrite target that is
at a 0x44-byte distance from the preceding 0x100-byte boundary, I
effectively just have to find an overwrite target that is at a
0x4-byte distance from the preceding 0x10-byte boundary, and then keep
doing syscalls and checking at what stack depth they execute until I
randomly get lucky and the stack lands in the right position.

With that in mind, I went looking for an overwrite target on the
stack, strongly inspired by [Seth's exploit that overwrote a spilled
register containing a length used in
`copy_from_user`](https://googleprojectzero.blogspot.com/2022/12/exploiting=
-CVE-2022-42703-bringing-back-the-stack-attack.html).
Targeting a normal `copy_from_user()` directly wouldn't work here - if
I incremented the 64-bit length used inside `copy_from_user()` by 4
GiB, then even if the copy failed midway through due to a userspace
fault, `copy_from_user()` would try to `memset()` the remaining kernel
memory to zero.

I discovered that, on the codepath `pipe_write -> copy_page_from_iter
-> copy_from_iter`, the 64-bit length variable `bytes` of
`copy_page_from_iter()` is stored in register `R14`, which is spilled
to the stack frame of `copy_from_iter()`; and this stack spill is in a
stack location where I can clobber it.

When userspace calls `write()` on a pipe, the kernel constructs an
iterator (`struct iov_iter`) that encapsulates the userspace memory
range passed to `write()`. (There are different types of iterators
that can encapsulate a single userspace range, a set of userspace
ranges, or various types of kernel memory.) Then, `pipe_write()`
(which is called `anon_pipe_write()` in newer kernels) essentially
runs a loop which allocates a new `pipe_buffer` slot in the pipe,
places a new page allocation in this pipe buffer slot, and copies up
to a page worth of data (`PAGE_SIZE` bytes) from the `iov_iter` to the
pipe buffer slot's page using `copy_page_from_iter()`.
`copy_page_from_iter()` effectively receives two length values: The
number of bytes that fit into the caller-provided page (`bytes`,
initially set to `PAGE_SIZE` here) and the number of bytes available
in the `struct iov_iter` encapsulating the userspace memory range
(`i->count`). The amount of data that will actually be copied is
limited by both.

If I manage to increment the spilled register `R14` which contains
`bytes` by 4 GiB while `copy_from_iter()` is busy copying data into
the kernel, then after `copy_from_iter()` returns,
`copy_page_from_iter()` will effectively no longer be bounded by
`bytes`, only by `i->count` (based on the length userspace passed to
`write()`); so it will do a second iteration, which copies into
out-of-bounds memory behind the pipe buffer page. If userspace calls
`write(fd, buf, 0x3000)`, and the overwrite happens in the middle of
copying bytes 0x1000-0x1fff of the userspace buffer into the second
pipe buffer page, then bytes 0x2000-0x2fff will be written
out-of-bounds behind the second pipe buffer page, at which point
`i->count` will drop to 0, terminating the operation.
>>>

<<<
# Takeaway: probabilistic mitigations against attackers with arbitrary read

When faced with an attacker who already has an arbitrary read
primitive, probabilistic mitigations that randomize something
differently on every operation can be ineffective if the attacker can
keep retrying until the arbitrary read confirms that the randomization
picked a suitable value or even work to the attacker's advantage by
lining up memory locations that could otherwise never overlap, as done
here using the kernel stack randomization feature.

Picking per-syscall random stack offsets at boottime might avoid this
issue, since to retry with different offsets, the attacker would have
to wait for the machine to reboot or try again on another machine.
However, that would break the protection for cases where the attacker
wants to line up two syscalls that use the same syscall number (such
as different `ioctl()` calls); and it could also weaken the protection
in cases where the attacker just needs to know what the randomization
offset for some syscall will be.

Somewhat relatedly,
[Blindside](https://www.vusec.net/projects/blindside/) demonstrated
that this style of attack can be pulled off without a normal arbitrary
read primitive, by =E2=80=9Cexploiting=E2=80=9D a real kernel memory corrup=
tion bug
during speculative execution in order to leak information needed for
subsequently exploiting the same memory corruption bug for real.
>>>
