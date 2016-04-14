Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jL21Jk7tKYnVULDskOKeq-QgQM6E0z6EuzmDMp5Sa2iBA@mail.gmail.com>
References: <1458631937-14593-1-git-send-email-bhe@redhat.com>
	<20160405015613.GA4654@x1.redhat.com>
	<CAGXu5jKtXndmfLNt1PZvL1oE5BXHDHsAcGBy=0V-nHg=6CA8HA@mail.gmail.com>
	<20160413101950.GC9482@gmail.com>
	<CAGXu5jL21Jk7tKYnVULDskOKeq-QgQM6E0z6EuzmDMp5Sa2iBA@mail.gmail.com>
Date: Wed, 13 Apr 2016 23:02:38 -0700
Message-ID: <CAGXu5jJFcT9CgKvJSJ9rDOz4D8fJRhDbxBGwOpQhUA2OyYPAzg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 00/20] x86, boot: kaslr cleanup and 64bit kaslr support
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 13, 2016 at 7:11 AM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Apr 13, 2016 at 3:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Kees Cook <keescook@chromium.org> wrote:
>>
>>> FWIW, I've also had this tree up in my git branches, and the 0day
>>> tester hasn't complained at all about it in the last two weeks. I'd
>>> really like to see this in -next to fix the >4G (mainly kexec) issues
>>> and get us to feature parity with the arm64 kASLR work (randomized
>>> virtual address).

So, I've done this and suddenly realized I hadn't boot-tested i386. It
doesn't work, unfortunately. (Which I find strange: I'd expect 0day to
have noticed...)

Baoquan, have you tested this on 32-bit systems? I get a variety of
failures. Either it boots okay, it reboots, or I get tons of pte
errors like this:

[    0.000000] clearing pte for ram above max_low_pfn: pfn: 37dcc pmd:
f9144f7c pmd phys: 39144f7c pte: f9a1b730 pte phys: 39a1b730

Can you confirm? I suspect relocation problems, but ran out of time
today to debug it.

I have the entire series with cleaned up changelogs and various other
refactorings up here now:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr/highmem

Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
