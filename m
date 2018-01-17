Date: Wed, 17 Jan 2018 11:42:34 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
In-Reply-To: <20180116210313.GA7791@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.20.1801171141430.23209@nuc-kabylake>
References: <1515531365-37423-1-git-send-email-keescook@chromium.org> <1515531365-37423-5-git-send-email-keescook@chromium.org> <alpine.DEB.2.20.1801101219390.7926@nuc-kabylake> <20180114230719.GB32027@bombadil.infradead.org> <alpine.DEB.2.20.1801160913260.3908@nuc-kabylake>
 <20180116160525.GF30073@bombadil.infradead.org> <alpine.DEB.2.20.1801161049320.5162@nuc-kabylake> <20180116174315.GA10461@bombadil.infradead.org> <alpine.DEB.2.20.1801161205590.1771@nuc-kabylake> <alpine.DEB.2.20.1801161215500.2945@nuc-kabylake>
 <20180116210313.GA7791@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: kmem_cache_attr (was Re: [PATCH 04/36] usercopy: Prepare for
 usercopy whitelisting)
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, linux-mm@kvack.org, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 16 Jan 2018, Matthew Wilcox wrote:

> struct kmem_cache_attr {
> 	char name[16];

That doesnt work. memcg needs long slab names. Sigh.
