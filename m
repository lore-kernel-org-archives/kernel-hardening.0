Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 08:57:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
Message-ID: <alpine.DEB.2.20.1601260856160.27338@east.gentwo.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC][PATCH 0/3] Speed up SLUB poisoning + disable checks
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 25 Jan 2016, Laura Abbott wrote:

> slub_debug=-:  7.437
> slub_debug=-:   7.932

So thats an almost 10% performance regression if the feature is not used.
The reason that posoning is on the slow path is because it is impacting
performance. Focus on optimizing the debug path without impacting the fast
path please.
