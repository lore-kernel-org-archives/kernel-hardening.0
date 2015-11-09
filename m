Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 16:49:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20151109134942.GB8264@mwanda>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
 <20151108221624.GP18797@mwanda>
 <alpine.DEB.2.10.1511082220500.2583@hadrien>
 <20151109054253.GQ18797@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151109054253.GQ18797@mwanda>
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops
 structures
To: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Actually, it looks like Emese Revfy is going to merge the GCC plugin
constify stuff sooner rather than later so maybe adding all these consts
isn't going to be needed.

regards,
dan carpenter
