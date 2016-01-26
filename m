Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 09:00:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1453770913-32287-4-git-send-email-labbott@fedoraproject.org>
Message-ID: <alpine.DEB.2.20.1601260858590.27338@east.gentwo.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org> <1453770913-32287-4-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 3/3] slub: Add option to skip consistency checks
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 25 Jan 2016, Laura Abbott wrote:

> SLUB debugging by default does checks to ensure consistency.
> These checks, while useful, are expensive for allocation speed.
> Features such as poisoning and tracing can stand alone without
> any checks. Add a slab flag to skip these checks.

I would suggest to rename the SLAB_DEBUG_FREE to SLAB_CONSISTENCY_CHECKS
instead. I think the flag is already used that way in a couple of places.

Flags generally enable stuff. Disabling what is enabled by others is
something that we want to avoid for simplicities sake.
