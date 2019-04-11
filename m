Date: Thu, 11 Apr 2019 10:32:23 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v3 1/3] module: Prepare for addition of new ro_after_init
 sections
In-Reply-To: <20190410195708.162185-1-joel@joelfernandes.org>
Message-ID: <alpine.LSU.2.21.1904111031580.27183@pobox.suse.cz>
References: <20190410195708.162185-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 10 Apr 2019, Joel Fernandes (Google) wrote:

> For the purposes of hardening modules by adding sections to
> ro_after_init sections, prepare for addition of new ro_after_init
> entries which we do in future patches. Create a table to which new
> entries could be added later. This makes it less error prone and reduce
> code duplication.
> 
> Cc: paulmck@linux.vnet.ibm.com
> Cc: rostedt@goodmis.org
> Cc: mathieu.desnoyers@efficios.com
> Cc: rcu@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> Cc: kernel-team@android.com
> Suggested-by: keescook@chromium.org
> Reviewed-by: keescook@chromium.org
> Acked-by: rostedt@goodmis.org
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M
