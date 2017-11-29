Date: Wed, 29 Nov 2017 11:28:52 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20171129172852.GA14545@mail.hallyn.com>
References: <20171128211659.GP729@wotan.suse.de>
 <CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
 <20171129134612.72ccb53d@alans-desktop>
 <20171129.095014.1909386937628805919.davem@davemloft.net>
 <20171129155406.i2lyclquj75lvtn4@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129155406.i2lyclquj75lvtn4@thunk.org>
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: Theodore Ts'o <tytso@mit.edu>, David Miller <davem@davemloft.net>, gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, mcgrof@kernel.org, tixxdz@gmail.com, luto@kernel.org, akpm@linux-foundation.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Theodore Ts'o (tytso@mit.edu):
> Half the problem here is that with containers, people are changing the
> security model, because they want to let untrusted users have "root",
> without really having "root".  Part of the fundamental problem is that
> there are some well-meaning, but fundamentally misguided people, who
> have been asserting: "Containers are just as secure as VM's".
> 
> Well, they are not.  And the sooner people get past this, the better
> off they'll be....

Just to be clear, module loading requires - and must always continue to
require - CAP_SYS_MODULE against the initial user namespace.  Containers
in user namespaces do not have that.

I don't believe anyone has ever claimed that containers which are not in
a user namespace are in any way secure.

(And as for the other claim, I'd prefer to stick to "VMs are in most
cases as insecure as properly configured containers" :)

-serge
