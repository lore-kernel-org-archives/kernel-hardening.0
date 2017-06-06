References: <20170605192216.21596-1-igor.stoppa@huawei.com>
 <20170605192216.21596-5-igor.stoppa@huawei.com>
 <71e91de0-7d91-79f4-67f0-be0afb33583c@schaufler-ca.com>
 <201706060550.HAC69712.OVFOtSFLQJOMFH@I-love.SAKURA.ne.jp>
 <ff5714b2-bbb0-726d-2fe6-13d4f1a30a38@huawei.com>
 <201706061954.GBH56755.QSOOFMFLtJFVOH@I-love.SAKURA.ne.jp>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <6c807793-6a39-82ef-93d9-29ad2546fc4c@huawei.com>
Date: Tue, 6 Jun 2017 14:12:26 +0300
MIME-Version: 1.0
In-Reply-To: <201706061954.GBH56755.QSOOFMFLtJFVOH@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/5] Make LSM Writable Hooks a command line option
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, casey@schaufler-ca.com, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org
Cc: paul@paul-moore.com, sds@tycho.nsa.gov, hch@infradead.org, labbott@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/06/17 13:54, Tetsuo Handa wrote:

[...]

> "Loading modules which are not compiled as built-in" is correct.
> My use case is to allow users to use LSM modules as loadable kernel
> modules which distributors do not compile as built-in.

Ok, so I suppose someone should eventually lock down the header, after
the additional modules are loaded.

Who decides when enough is enough, meaning that all the needed modules
are loaded?
Should I provide an interface to user-space? A sysfs entry?

[...]

> Unloading LSM modules is dangerous. Only SELinux allows unloading
> at the risk of triggering an oops. If we insert delay while removing
> list elements, we can easily observe oops due to free function being
> called without corresponding allocation function.

Ok. But even in this case, the sys proposal would still work.
It would just stay unused.


--
igor
