Date: Fri, 9 Mar 2018 13:35:43 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] net: ipv6: xfrm6_state: remove VLA usage
Message-ID: <20180309123543.defont7is6fyxt4d@gauss3.secunet.de>
References: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
To: Andreas Christoforou <andreaschristofo@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 09, 2018 at 02:21:46PM +0200, Andreas Christoforou wrote:
> The kernel would like to have all stack VLA usage removed[1].
> 
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>

Can you please explain why you want this change?
