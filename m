References: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <2a28d30a-22d3-33ff-581c-f1347fbbae74@nmatt.com>
Date: Thu, 8 Jun 2017 16:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 0/6] LSM: Security module blob
 management
To: Casey Schaufler <casey@schaufler-ca.com>, LSM <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKLM <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/8/17 4:43 PM, Casey Schaufler wrote:
> Subject: [PATCH 0/6] LSM: Security module blob management
> 
> This patch set moves management of security blobs out of
> the Linux security modules and into the security module
> infrastructure. This allows "major" security modules that
> use blobs to be stacked, just as "minor" modules that
> do not use blobs can be stacked today. It stops short of
> providing a safe interface for the Netlabel and SO_PEERSEC.
> As a result, any of the existing security modules may be
> used in combination except for SELinux and Smack.

Very excited about this! I can definitely see use cases for special
purpose LSMs that require data blobs but do not replace things like
SELinux, SMACK or AppArmor. I have had a few ideas recently that would
not be possible under the current setup of one shared blob.

Matt
