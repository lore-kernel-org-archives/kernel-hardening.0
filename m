Date: Fri, 11 Aug 2017 15:52:05 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170811215205.x7e3zhx2mkseg7jy@smitten>
References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-7-tycho@docker.com>
 <f6a42032-d4e5-f488-3d55-1da4c8a4dbaf@redhat.com>
 <20170811211302.limmjv4rmq23b25b@smitten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811211302.limmjv4rmq23b25b@smitten>
Subject: Re: [kernel-hardening] [PATCH v5 06/10] arm64/mm: Disable section
 mappings if XPFO is enabled
To: Laura Abbott <labbott@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 11, 2017 at 03:13:02PM -0600, Tycho Andersen wrote:
> You're suggesting something like this instead? Seems to work fine.

And in fact, using this patch instead means that booting on 4k pages
works too... I guess because NO_BLOCK_MAPPINGS is looked at in a few
other places that matter too? Anyway, I'll use this patch instead,
thanks for the suggestion!

Tycho
