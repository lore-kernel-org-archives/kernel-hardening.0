Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 10:12:23 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415081223.GF30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
 <1460672954-32567-6-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460672954-32567-6-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v5 05/21] x86, boot: Calculate decompression size during
 boot not build
To: Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> 
> Currently z_extract_offset is calculated in boot/compressed/mkpiggy.c.

What is the high level meaning of z_extract_offset? I cannot tell without reading 
the code - and the point of changelogs is for them to be readable without having 
to read the code.

The rest of the changelog is pretty good.

Thanks,

	Ingo
