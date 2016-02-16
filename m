Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Feb 2016 10:30:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1455561864-4217-3-git-send-email-labbott@fedoraproject.org>
Message-ID: <alpine.DEB.2.20.1602161029440.4158@east.gentwo.org>
References: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org> <1455561864-4217-3-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCHv2 2/4] slub: Fix/clean free_debug_processing return
 paths
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 15 Feb 2016, Laura Abbott wrote:

> Since 19c7ff9ecd89 ("slub: Take node lock during object free checks")
> check_object has been incorrectly returning success as it follows
> the out label which just returns the node. Thanks to refactoring,
> the out and fail paths are now basically the same. Combine the two
> into one and just use a single label.

Acked-by: Christoph Lameter <cl@linux.com>
