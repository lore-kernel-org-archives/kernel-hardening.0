Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 22 Dec 2015 14:01:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <CA+rthh_agt=YmHGUvBo_+-psOg06DYySqyvkvNNuPmrCKiBC2w@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1512221400100.15237@east.gentwo.org>
References: <1450755641-7856-1-git-send-email-laura@labbott.name> <1450755641-7856-7-git-send-email-laura@labbott.name> <CA+rthh-X2jvGpptE72CCbOx2MdkukJSCu621+9ymMJ_pCQ9t+w@mail.gmail.com> <56798D8F.9090402@labbott.name>
 <CA+rthh_agt=YmHGUvBo_+-psOg06DYySqyvkvNNuPmrCKiBC2w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: Mathias Krause <minipli@googlemail.com>
Cc: Laura Abbott <laura@labbott.name>, kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 22 Dec 2015, Mathias Krause wrote:

> How many systems, do you think, are running with enabled DEBUG_SLAB /
> SLUB_DEBUG in production? Not so many, I'd guess. And the ones running
> into issues probably just disable DEBUG_SLAB / SLUB_DEBUG.

All systems run with SLUB_DEBUG in production. SLUB_DEBUG causes the code
for debugging to be compiled in. Then it can be enabled later with a
command line parameter.
