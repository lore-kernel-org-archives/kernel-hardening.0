Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 14 Jul 2011 20:31:24 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110714163123.GA15828@albatros>
References: <20110612130953.GA3709@albatros>
 <20110706173631.GA5431@albatros>
 <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
 <20110706185932.GB3299@albatros>
 <20110711165900.GA14319@openwall.com>
 <20110711185635.GA2072@albatros>
 <20110713094856.GA20924@openwall.com>
 <20110714141557.GA29900@openwall.com>
 <20110714142755.GA30981@albatros>
 <20110714151450.GA30153@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714151450.GA30153@openwall.com>
Subject: [kernel-hardening] compile time warnings in libc for setuid() unused result (was:
 RLIMIT_NPROC check in set_user())
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

Similar thing worth trying to push upstream: for glibc (probably other
widespread libc implementations) edit headers to make compiler complain
if don't use setuid(2) and other capability dropping functions result
code.  It would effectively signal distro maintainers (probably to the
program authors) that there is some significant issue(s) in the sources.

Thanks,

-- 
Vasiliy
