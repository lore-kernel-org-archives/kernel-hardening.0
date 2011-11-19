Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 19 Nov 2011 12:18:46 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111119081846.GA3419@albatros>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111119075733.GB2675@albatros>
 <20111119081012.GC2675@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119081012.GC2675@albatros>
Subject: [kernel-hardening] Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Glauber Costa <glommer@parallels.com>, Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>, Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 19, 2011 at 12:10 +0400, Vasiliy Kulikov wrote:
> Also, if one should have an ability to learn IDs of specific object
> types and the set of types is very limited, it's much safer to have one
> increasing u64 counter for each created object of one of these types.
> The exposed to userspace data will be:
> 
>     ID = hash(counter ^ cookie)

Even hash(counter) without any cookie and counter is randomly generated at boot time.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
