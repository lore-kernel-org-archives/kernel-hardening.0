Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 7 May 2016 07:40:58 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160507054058.GA18499@gmail.com>
References: <1462572095-11754-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462572095-11754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 0/3] x86/KASLR: Build identity mappings on demand
To: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> I'm going back to small steps. :)
>
> This series lets the x86_64 compressed boot environment build
> page table identity mappings on demand. This will be used once
> we begin randomizing the physical memory position beyond the
> existing identity maps.

This series was much better, thanks! I've applied them to tip:x86/boot and will 
push them out if they pass testing.

I also applied Boris's type casting cleanups and your comments improval patch:

  ed09acde44e3 x86/KASLR: Improve comments around the mem_avoid[] logic

Thanks,

	Ingo
