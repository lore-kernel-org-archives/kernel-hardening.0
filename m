Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Fri, 29 Jan 2016 04:55:44 +0100
Message-ID: <2210767.i4rORgf7qQ@vostro.rjw.lan>
In-Reply-To: <1454035099-31583-3-git-send-email-labbott@fedoraproject.org>
References: <1454035099-31583-1-git-send-email-labbott@fedoraproject.org> <1454035099-31583-3-git-send-email-labbott@fedoraproject.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCHv2 2/2] mm/page_poisoning.c: Allow for zero poisoning
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, linux-pm@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thursday, January 28, 2016 06:38:19 PM Laura Abbott wrote:
> By default, page poisoning uses a poison value (0xaa) on free. If this
> is changed to 0, the page is not only sanitized but zeroing on alloc
> with __GFP_ZERO can be skipped as well. The tradeoff is that detecting
> corruption from the poisoning is harder to detect. This feature also
> cannot be used with hibernation since pages are not guaranteed to be
> zeroed after hibernation.
> 
> Credit to Grsecurity/PaX team for inspiring this work
> 
> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>

The hibernation disabling part is fine by me.

Please feel free to add an ACK from me to this if that helps.

Thanks,
Rafael
