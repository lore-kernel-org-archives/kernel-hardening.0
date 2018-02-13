Date: Tue, 13 Feb 2018 06:56:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] GCC release 8 support for gcc-plugins
Message-ID: <20180213145632.GA7937@infradead.org>
References: <123377.1517765678@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <123377.1517765678@turing-police.cc.vt.edu>
To: valdis.kletnieks@vt.edu
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 04, 2018 at 12:34:38PM -0500, valdis.kletnieks@vt.edu wrote:
> For reasons totally beyond my understanding, gcc 8 changed the
> order of two structure member, which leads to an error:

I'm a little late on this, but isn't the whole point of C99 initializers
that field order should not matter at all?
