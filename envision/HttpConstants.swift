//
//  HttpConstants.swift
//  crm
//
//  Created by long on 15/8/8.
//  Copyright (c) 2015年 long. All rights reserved.
//

import Foundation

var ROOTURL = "http://118.242.16.162:5580/envision/api/"

//登陆
let  LOGIN = ROOTURL + "applicantLogin.htm"

//注册
let  REGISTER = ROOTURL + "applicantRegister.htm"

//首页浮动图片
let GET_MARQUESS = ROOTURL + "getMarquee.htm"

//获取首页种子
let getSeedList = ROOTURL + "getSeedList.htm"

//创建新用户
let applicantRegister = ROOTURL + "applicantRegister.htm"

let getCode = ROOTURL + "getCode.htm"

let findPassword = ROOTURL + "applicantFindPassword.htm"

let searchAcademy = ROOTURL + "searchAcademy.htm"

let searchSpecialty = ROOTURL + "searchSpecialty.htm"

let applicantUpdate = ROOTURL + "applicantUpdate.htm"

let getjobInfoUrl = ROOTURL + "getjobInfoUrl.htm"

//上传文件
let uploadFile = ROOTURL + "uploadFileMultipart.htm"

let modifyUser = ROOTURL + "modifyUser.htm"

//获取会馆列表
let  getClubList  = ROOTURL + "getClubList.htm"

//根据首字母来选择城市列表
let  getNewCityListByLetter  = ROOTURL + "getNewCityListByLetter.htm"


//获取产品详情
let  GET_PRODUCT_DETAIL = ROOTURL + "GetProductDetail/ShowProductDetail"


//创建预约单
let  CREATE_OPPOTUNITY = ROOTURL + "CreateOppotunity/Create"

//创建报单
let CREATE_ORDER = ROOTURL + "CreateOrder/Create"

//查询预约单
let GET_OPPORTUNITY_LIST = ROOTURL + "GetOppotunityList/ShowOppotunity"

//查询报单
let GET_ORDER = ROOTURL + "GetOrderList/OrderList"

//查询客户
let GET_CUSTOMERLIST = ROOTURL + "GetCustomerList/ShowCustomer"

//查询用户信息
let GET_USERINFO = ROOTURL + "GetUserBasicInfo/ShowUserBasicInfo"

//查询合同
let GET_CONTRACT = ROOTURL + "GetContractList/ShowContract"