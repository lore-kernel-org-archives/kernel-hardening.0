Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 16:30:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20151109133026.GA8264@mwanda>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
 <20151108221624.GP18797@mwanda>
 <alpine.DEB.2.10.1511082220500.2583@hadrien>
 <20151109054253.GQ18797@mwanda>
 <alpine.DEB.2.10.1511090634180.2593@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1511090634180.2593@hadrien>
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: kernel-hardening@lists.openwall.com
Cc: Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Yeah, that's tricky and I don't have an answer but marking things as
const is a worth while in itself because it makes static some analysis
easier.

regards,
dan carpenter
