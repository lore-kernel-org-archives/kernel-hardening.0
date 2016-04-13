Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160413101950.GC9482@gmail.com>
References: <1458631937-14593-1-git-send-email-bhe@redhat.com>
	<20160405015613.GA4654@x1.redhat.com>
	<CAGXu5jKtXndmfLNt1PZvL1oE5BXHDHsAcGBy=0V-nHg=6CA8HA@mail.gmail.com>
	<20160413101950.GC9482@gmail.com>
Date: Wed, 13 Apr 2016 07:11:44 -0700
Message-ID: <CAGXu5jL21Jk7tKYnVULDskOKeq-QgQM6E0z6EuzmDMp5Sa2iBA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 00/20] x86, boot: kaslr cleanup and 64bit kaslr support
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 13, 2016 at 3:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> FWIW, I've also had this tree up in my git branches, and the 0day
>> tester hasn't complained at all about it in the last two weeks. I'd
>> really like to see this in -next to fix the >4G (mainly kexec) issues
>> and get us to feature parity with the arm64 kASLR work (randomized
>> virtual address).
>
> So I started applying the patches, started fixing up changelogs and gave up on
> patch #3.
>
> Changelogs of such non-trivial code need to be proper English and need to be
> understandable.
>
> For example patch #3 starts with:
>
>> Current z_extract_offset is calculated in boot/compressed/mkpiggy.c. The problem
>> is in mkpiggy.c we don't know the detail of decompressor. Then we just get a
>> rough z_extract_offset according to extra_bytes. As we know extra_bytes can only
>> promise a safety margin when decompressing. In fact this brings some risks:
>
> Beyond the bad grammar of the _first word_ of the changelog, this is not a proper
> high level description of the change. A _real_ high level description would be
> something like:
>
>   > Currently z_extract_offset is calculated during kernel build time. The problem
>   > with that method is that at this stage we don't yet know the decompression
>   > buffer sizes - we only know that during bootup.
>   >
>   > Effects of this are that when we calculate z_extract_offset during the build
>   > we don't know the precise decompression details, we'll only get a rough
>   > estimation of z_extract_offset.
>   >
>   > Instead of that we want to calculate it during bootup.
>
> etc. etc. - the whole series is _full_ of such crappy changelogs that make it
> difficult for me and others to see whether the author actually _understands_ the
> existing code or is hacking away on it. It's also much harder to review and
> validate.
>
> This is totally unacceptable.
>
> Please make sure every changelog starts with a proper high level description that
> tells the story and convinces the reader about what the problem is and what the
> change should be.
>
> And part of that are the patch titles. Things like:
>
> Subject: [PATCH v3 03/19] x86, boot: Move z_extract_offset calculation to header.S
>
> are absolutely mindless titles. A better title would be:
>
>       x86/boot: Calculate precise decompressor parameters during bootup, not build time
>
> ... or something like that. Even having read the changelog 3 times I'm unsure what
> the change really is about.

I'll rewrite all the changelogs and resend the series. Thanks taking a look! :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
