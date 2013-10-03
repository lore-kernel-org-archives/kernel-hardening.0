Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524DEE6B.2060105@zytor.com>
Date: Thu, 03 Oct 2013 15:23:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1380833605-26313-1-git-send-email-keescook@chromium.org> <1380833605-26313-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1380833605-26313-4-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/7] x86, kaslr: find minimum safe relocation position
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/03/2013 01:53 PM, Kees Cook wrote:
> Examine all the known unsafe areas and avoid them by just raising the
> minimum relocation position to be past them.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

> +	/* Minimum location must be above all these regions: */

This is highly problematic.  The standard protocol is to hoist the
initramfs as high as possible in memory, so this may really unacceptably
restrict the available range.

It would be better to treat these the same as reserved regions in the
e820 map as far as the address space picking algorithm is concerned.

	-hpa
