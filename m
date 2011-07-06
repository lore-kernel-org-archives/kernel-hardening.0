Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 6 Jul 2011 22:35:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110706183511.GA3299@albatros>
References: <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110705142659.GA18290@peqn>
 <20110705145033.GA3052@albatros>
 <20110705155755.GB14784@peqn>
 <20110705174200.GC6102@albatros>
 <20110706163140.GA24949@peqn>
 <20110706165732.GA4820@albatros>
 <20110706180831.GA15379@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706180831.GA15379@redhat.com>
Subject: Re: [kernel-hardening] Re: [PATCH] shm: handle separate PID
 namespaces case
To: kernel-hardening@lists.openwall.com
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 06, 2011 at 20:08 +0200, Oleg Nesterov wrote:
> Cough. I stil think exit_shm() should check .in_use != 0 lockless.

Give me a proof it is safe for all architectures :)

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
