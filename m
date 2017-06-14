Date: Wed, 14 Jun 2017 18:47:08 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20170610025912.6499-5-Jason@zx2c4.com>
Message-ID: <alpine.LRH.2.20.1706141846530.27733@namei.org>
References: <20170610025912.6499-1-Jason@zx2c4.com> <20170610025912.6499-5-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] [PATCH 4/6] security/keys: use constant time
 memory comparison for macs
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, David Safford <safford@us.ibm.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 10 Jun 2017, Jason A. Donenfeld wrote:

> Otherwise, we enable a MAC forgery via timing attack.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: David Safford <safford@us.ibm.com>
> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: keyrings@vger.kernel.org
> Cc: stable@vger.kernel.org


Reviewed-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<jmorris@namei.org>
