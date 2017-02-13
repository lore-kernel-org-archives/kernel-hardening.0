Date: Mon, 13 Feb 2017 02:38:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170213103815.GA5131@infradead.org>
References: <1486625901-10094-1-git-send-email-dwindsor@gmail.com>
 <CAEXv5_jUa8Av4JABoKSAueiLHSLzibMvaE-8DrVcxZHFceckMg@mail.gmail.com>
 <1486816302.4233.29.camel@poochiereds.net>
 <CAEXv5_gd7F-eaazzU1BWPzH4huhEcO1Y-FWov5UP9T+6R+fv-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_gd7F-eaazzU1BWPzH4huhEcO1Y-FWov5UP9T+6R+fv-A@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC][PATCH] nfsd: add +1 to reference counting scheme for
 struct nfsd4_session
To: David Windsor <dwindsor@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com, Bruce Fields <bfields@fieldses.org>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2017 at 09:01:15AM -0500, David Windsor wrote:
> I'm not sure there's another way to accomplish what we need
> (initializing struct nfsd4_session objects with refcount=1) without
> also modifying the freeable reference state.  After migrating to the
> refcount_t API, if we leave init_session() as is, the first call to
> nfsd4_get_session_locked() will fail:

Which is a pretty clear indicator that this code should simply not
migrate to the recount_t API.  Why was it even considered if the
conversion is obviously broken?
