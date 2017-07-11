From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20170710150603.387-1-igor.stoppa@huawei.com>
In-Reply-To: <20170710150603.387-1-igor.stoppa@huawei.com>
Message-Id: <201707112012.GBC05774.QOtOSLJVFHFOFM@I-love.SAKURA.ne.jp>
Date: Tue, 11 Jul 2017 20:12:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH v10 0/3] mm: security: ro protection for dynamic data
To: igor.stoppa@huawei.com, jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, labbott@redhat.com, hch@infradead.org
Cc: paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Igor Stoppa wrote:
> - I had to rebase Tetsuo Handa's patch because it didn't apply cleanly
>   anymore, I would appreciate an ACK to that or a revised patch, whatever 
>   comes easier.

Since we are getting several proposals of changing LSM hooks and both your proposal
and Casey's "LSM: Security module blob management" proposal touch same files, I think
we can break these changes into small pieces so that both you and Casey can make
future versions smaller.

If nobody has objections about direction of Igor's proposal and Casey's proposal,
I think merging only "[PATCH 2/3] LSM: Convert security_hook_heads into explicit
array of struct list_head" from Igor's proposal and ->security accessor wrappers (e.g.

  #define selinux_security(obj) (obj->security)
  #define smack_security(obj) (obj->security)
  #define tomoyo_security(obj) (obj->security)
  #define apparmor_security(obj) (obj->security)

) from Casey's proposal now helps solving deadlocked situation.
