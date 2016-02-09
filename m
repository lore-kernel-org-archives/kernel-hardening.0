Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 9 Feb 2016 19:55:32 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160209195532.fb72f47c5543cc0ada11653a@gmail.com>
In-Reply-To: <CAGXu5jJb4aJKQDTscJqUve6tO4S=5zU+X7ZGw87MfDoFMQSxLw@mail.gmail.com>
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
	<20160207223140.830691e83ab579f46f991410@gmail.com>
	<CAGXu5jJb4aJKQDTscJqUve6tO4S=5zU+X7ZGw87MfDoFMQSxLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/3] Add Cyclomatic complexity GCC plugin
To: Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 8 Feb 2016 20:23:12 -0800
Kees Cook <keescook@chromium.org> wrote:
> > +         The complexity M of a function's control flow graph is defined as:
> > +          M = E - N + 2P
> > +         where
> > +
> > +         E = the number of edges
> > +         N = the number of nodes
> > +         P = the number of connected components (exit nodes).
> > +
> > +         See Documentation/gcc-plugins.txt for details.
> 
> Is this plugin documented there? I don't see a chunk for that in this patch.

No yet, please see my other response.

--
Emese
