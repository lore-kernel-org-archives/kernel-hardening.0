References: <alpine.LRH.2.20.1702131631490.8914@namei.org>
 <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <4e6e79af-a37f-c48e-5932-9b29270ac034@schaufler-ca.com>
Date: Mon, 13 Feb 2017 12:44:41 -0800
MIME-Version: 1.0
In-Reply-To: <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks as __ro_after_init
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org, linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2/13/2017 2:33 AM, Tetsuo Handa wrote:
> James Morris wrote:
>> As the regsitration of LSMs is performed during init and then does
>> not change, we can mark all of the regsitration hooks as __ro_after_init.
>>
>> Signed-off-by: James Morris <james.l.morris@oracle.com>
> This patch makes LKM based LSMs (e.g. AKARI) impossible.

When a mechanism to do LKM based modules work is proposed
it could include ifdef's around the __ro_after_init. I'm
assuming that enabling LKM modules is something we'd want to
make optional.

> I'm not happy with this patch.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
