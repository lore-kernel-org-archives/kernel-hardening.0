Subject: Re: [PATCH 0/2] Stackleak for arm64
References: <20180221011303.20392-1-labbott@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <ee58357e-4c98-ec67-60de-0f8283261727@linux.com>
Date: Wed, 21 Feb 2018 17:48:28 +0300
MIME-Version: 1.0
In-Reply-To: <20180221011303.20392-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 21.02.2018 04:13, Laura Abbott wrote:
> This is the arm64 version of the STACKLEAK plugin originall from
> grsecurity. See
> https://marc.info/?l=kernel-hardening&m=151880470609808 for the
> full x86 version. This is based on top of Kees' branch for stackleak
> and has been cleaned up to use a few macros from that branch.
> 
> Comments welcome, if there are no major objections Kees will queue this
> up to get some CI testing. This passed both of the LKDTM tests.

Hello, Laura,

Thank you. I'll take some time to learn your patches and test them on my LeMaker
HiKey board. I'll return with the feedback.

Best regards,
Alexander
