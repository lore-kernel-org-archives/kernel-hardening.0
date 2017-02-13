Date: Mon, 13 Feb 2017 04:12:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170213121238.GA4753@infradead.org>
References: <1486625901-10094-1-git-send-email-dwindsor@gmail.com>
 <CAEXv5_jUa8Av4JABoKSAueiLHSLzibMvaE-8DrVcxZHFceckMg@mail.gmail.com>
 <1486816302.4233.29.camel@poochiereds.net>
 <CAEXv5_gd7F-eaazzU1BWPzH4huhEcO1Y-FWov5UP9T+6R+fv-A@mail.gmail.com>
 <20170213103815.GA5131@infradead.org>
 <CAEXv5_g=DS4wk0mgZuw-doVCqountb-CxZki1LOoQH-P7W1U4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_g=DS4wk0mgZuw-doVCqountb-CxZki1LOoQH-P7W1U4A@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC][PATCH] nfsd: add +1 to reference counting scheme for
 struct nfsd4_session
To: David Windsor <dwindsor@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@poochiereds.net>, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com, Bruce Fields <bfields@fieldses.org>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 13, 2017 at 06:42:56AM -0500, David Windsor wrote:
> I'm not sure this is a sound argument for not converting to
> refcount_t.

It's an argument again the way how this patch was sent.  Please take care
of all the trivial conversions first, and then do anything non-trivial
on a case by case basis.
