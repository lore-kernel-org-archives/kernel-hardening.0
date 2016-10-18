Reply-To: kernel-hardening@lists.openwall.com
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <58061416.7020209@oracle.com>
Date: Tue, 18 Oct 2016 17:52:46 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Use-after-free and management of reference counts
To: kernel-hardening@lists.openwall.com, Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Recently I studied the reported CVEs of last 2 years and there were
fair number of use-after-free bugs. Usually we also see many reports
of use-after-free bugs in the LKML [reported by one or other tools].

Also, at Kernel recipes Jonathan Corbet  mentioned reference counts as
a security issue. I believe if we have more kernel hardening patches
then we can avoid such bugs. I was wondering if there is some ongoing
work in the both [use-after-free and management of reference counts]
of these areas?

If not, then I would like to work on the same. Any pointers on this
would be appreciated.

Thank you.

-- 
Vaishali
