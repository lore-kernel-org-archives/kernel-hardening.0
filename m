Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Nov 2016 16:31:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20161107163128.GA11975@e104818-lin.cambridge.arm.com>
References: <1477585654-8908-1-git-send-email-labbott@redhat.com>
 <20161030150307.33vc2m7y5y6wzbqc@localhost>
 <20161107153802.GJ19796@leverpostej>
 <07589590-7b7d-4ba1-67af-b39c40b16939@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07589590-7b7d-4ba1-67af-b39c40b16939@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv4 0/4] WX checking for arm64
To: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, David Brown <david.brown@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2016 at 08:26:34AM -0800, Laura Abbott wrote:
> On 11/07/2016 07:38 AM, Mark Rutland wrote:
> >From 06fef1ad1138d0808eec770e64458a350941bd2d Mon Sep 17 00:00:00 2001
> >From: Mark Rutland <mark.rutland@arm.com>
> >Date: Mon, 7 Nov 2016 15:24:40 +0000
> >Subject: [PATCH] Fix KASAN splats with DEBUG_WX
[...]
> Acked-by: Laura Abbott <labbott@redhat.com>

Thanks. I'll queue the patch on top of the others.

-- 
Catalin
